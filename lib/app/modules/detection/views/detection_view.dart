import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../controllers/detection_controller.dart';

class DetectionView extends GetView<DetectionController> {
  const DetectionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Height Measurement")),
      body: Center(
        child: Obx(() {
          if (controller.isCameraInitialized.isTrue) {
            return CameraPreview(
                controller.cameraController!); // Display camera feed
          } else {
            return const Text("Loading camera...");
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.captureImage();
          if (controller.detectedPoses.isNotEmpty) {
            Get.toNamed('/result');
          }
        },
        tooltip: 'Capture Image',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
