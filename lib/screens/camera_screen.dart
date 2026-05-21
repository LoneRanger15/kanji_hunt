import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../models/new_kanji_model.dart';
import '../widgets/kanji_card.dart';
import '../data/kanji_repository.dart';
import '../models/kanji_level.dart';
import '../services/storage_services.dart';
import 'dart:io';
import 'dart:math';

Kanji? detectedKanji;
bool isFlashOn = false;
bool isImageCaptured = false;
bool isScanning = false;
bool noObjectFound = false;
XFile? capturedImage;

class CameraScreen extends StatefulWidget {
  final KanjiLevel level;
  const CameraScreen({super.key, required this.level});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();

    detectedKanji = null;
    isImageCaptured = false;
    isScanning = false;

    initCamera();
  }

  Future<void> initCamera() async {
    var status = await Permission.camera.request();

    if (!status.isGranted) {
      print("Camera permission denied");
      return;
    }

    cameras = await availableCameras();

    if (cameras.isEmpty) {
      print("No camera found");
      return;
    }

    controller = CameraController(
      cameras[0], // back camera
      ResolutionPreset.medium,
    );

    await controller!.initialize();

    await controller!.setFlashMode(FlashMode.off);

    isFlashOn = false;

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {
    if (controller == null || !controller!.value.isInitialized) return;
    if (controller!.value.isTakingPicture) return;

    try {
      final image = await controller!.takePicture();

      if (!mounted) return;

      setState(() {
        capturedImage = image;
        isImageCaptured = true;
        isScanning = true;
        detectedKanji = null;
      });

      // ⏳ UX delay
      await Future.delayed(const Duration(seconds: 1));

      await processImage(image.path);

      // ⏳ small buffer for smooth transition
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      setState(() {
        isScanning = false;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> processImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);

    final imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.85),
    );

    try {
      final labels = await imageLabeler.processImage(inputImage);

      // Highest confidence labels first
      labels.sort((a, b) => b.confidence.compareTo(a.confidence));

      final kanjiList = KanjiRepository.getByLevel(widget.level);

      Kanji? bestMatch;
      double bestConfidence = 0;

      for (final label in labels) {
        final text = label.label.toLowerCase().trim();

        print("LABEL: $text (${label.confidence})");

        for (final kanji in kanjiList) {
          final match = kanji.keywords.any(
            (k) => text == k.toLowerCase().trim(),
          );

          if (match && label.confidence > bestConfidence) {
            bestConfidence = label.confidence;
            bestMatch = kanji;
          }
        }
      }

      if (bestMatch != null) {
        await StorageService.saveKanji(bestMatch.level, bestMatch.id);

        if (!mounted) return;

        setState(() {
          detectedKanji = bestMatch;
        });

        print(
          "BEST MATCH: ${bestMatch.kanji} (${bestMatch.meaning}) "
          "confidence: $bestConfidence",
        );
      } else {
        if (!mounted) return;

        const Color accentColor = Color.fromARGB(255, 242, 89, 120);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              title: const Text(
                "No Match Found",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              content: const Text(
                "Couldn't recognize any Kanji object. Try again!",
                style: TextStyle(color: Colors.black54),
              ),
              actionsPadding: const EdgeInsets.all(12),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // back to camera
                    },
                    child: const Text(
                      "Hunt Again",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("ML ERROR: $e");
    } finally {
      imageLabeler.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Future<void> toggleFlash() async {
      if (controller == null) return;

      isFlashOn = !isFlashOn;

      await controller!.setFlashMode(
        isFlashOn ? FlashMode.torch : FlashMode.off,
      );

      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Stack(
        children: [
          // ✅ CAMERA or CAPTURED IMAGE
          SizedBox.expand(
            child: isImageCaptured && capturedImage != null
                ? Image.file(
                    File(capturedImage!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : (controller != null &&
                      controller!.value.isInitialized &&
                      controller!.value.previewSize != null)
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller!.value.previewSize!.height,
                      height: controller!.value.previewSize!.width,
                      child: IgnorePointer(child: CameraPreview(controller!)),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          // ✅ KanjiCard OVER camera
          if (detectedKanji != null && !isScanning)
            Center(
              child: KanjiCard(
                key: ValueKey(
                  "${detectedKanji!.kanji}_${detectedKanji!.level}",
                ),
                kanji: detectedKanji!,
              ),
            ),

          // 🔦 Flash button
          if (detectedKanji == null)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: toggleFlash,
              ),
            ),

          // 📸 Capture button
          if (detectedKanji == null)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      captureImage();
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
