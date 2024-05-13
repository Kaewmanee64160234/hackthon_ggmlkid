import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class DetectionController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  // Observable image path
  var imagePath = ''.obs;
  final RxBool isCameraInitialized = false.obs;
  List<Pose> detectedPoses = [];
  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await cameraController!.initialize();
      isCameraInitialized.value = true;
    }
  }

  // Capture image and update path
  Future<void> captureImage() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      final image = await cameraController!.takePicture();
      detectPoses(image.path);
    }
  }

  Future<void> detectPoses(String imagePath_) async {
    final inputImage = InputImage.fromFilePath(imagePath_);
    final poseDetector = GoogleMlKit.vision.poseDetector();
    detectedPoses = await poseDetector.processImage(inputImage);
    imagePath.value = imagePath_;
    print(detectedPoses);
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
