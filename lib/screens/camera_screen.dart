import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../models/kanji_model.dart';
import '../widgets/kanji_card.dart';
import '../data/kanji_data.dart';
import 'dart:io';

Kanji? detectedKanji;
bool isFlashOn = false;
bool isImageCaptured = false;
bool isScanning = false;
bool noObjectFound = false;
XFile? capturedImage;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

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
    print("Processing image...");

    final inputImage = InputImage.fromFilePath(path);

    final imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.6),
    );

    try {
      final labels = await imageLabeler.processImage(inputImage);

      print("Detected labels:");

      for (final label in labels) {
        final text = label.label.toLowerCase();

        print("Checking: $text");

        for (final kanji in kanjiList) {
          if (kanji.keywords.any((k) => text.contains(k))) {
            print("MATCH FOUND: ${kanji.meaning}");

            if (!mounted) return;

            setState(() {
              detectedKanji = kanji;
            });

            return;
          }
        }
      }

      print("No match found");
    } catch (e) {
      print("ML ERROR: $e");
    } finally {
      imageLabeler.close(); // ✅ ALWAYS runs
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
            Center(child: KanjiCard(kanji: detectedKanji!)),

          // 🔦 Flash button
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
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print("BUTTON CLICKED");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Button Pressed")),
                    );
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
