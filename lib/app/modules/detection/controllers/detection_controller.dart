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
  RxDouble height = 0.0.obs;
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
    height.value = calculateHeight(detectedPoses);
  }

  double calculateHeight(List<Pose> poses) {
    if (poses.isEmpty) return 0;

    // Get the first detected pose
    Pose pose = poses.first;

    // Landmarks
    PoseLandmark? headTop = pose.landmarks[
        PoseLandmarkType.leftEye]; // Using left eye as an approximation
    PoseLandmark? ankleLeft = pose.landmarks[PoseLandmarkType.leftAnkle];
    PoseLandmark? ankleRight = pose.landmarks[PoseLandmarkType.rightAnkle];

    if (headTop == null || ankleLeft == null || ankleRight == null) {
      return 0; // Cannot calculate height without essential points
    }

    // Calculate average ankle position
    double ankleAverageY = (ankleLeft.y + ankleRight.y) / 2;

    // Calculate pixel distance from head top to average ankle position
    double heightInPixels = ankleAverageY - headTop.y;

    // Convert pixel distance to real world measurement
    double heightInCentimeters = pixelToCentimeters(heightInPixels);

    return heightInCentimeters;
  }

  double pixelToCentimeters(double pixels) {
    // Placeholder conversion factor
    double conversionFactor =
        0.0264; // Example conversion factor: depends on image DPI and distance
    return pixels * conversionFactor;
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
