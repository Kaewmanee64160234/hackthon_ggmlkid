import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class DetectionController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  var imagePath = ''.obs;
  final RxBool isCameraInitialized = false.obs;
  List<Pose> detectedPoses = [];
  RxDouble height = 0.0.obs;

  // Conversion factor (initialize with a default or calculated value)
  RxDouble conversionFactor =
      (0.0264).obs; // Placeholder, should be calculated via calibration
  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  void calibrateConversionFactor(
      double knownHeightCm, double knownHeightPixels) {
    conversionFactor.value = knownHeightCm / knownHeightPixels;
  }

  double pixelToCentimeters(double pixels) {
    return pixels * conversionFactor.value;
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
    Pose pose = poses.first;
    PoseLandmark? headTop = pose.landmarks[PoseLandmarkType.leftEye];
    PoseLandmark? ankleLeft = pose.landmarks[PoseLandmarkType.leftAnkle];
    PoseLandmark? ankleRight = pose.landmarks[PoseLandmarkType.rightAnkle];

    if (headTop == null || ankleLeft == null || ankleRight == null) {
      return 0;
    }

    double ankleAverageY = (ankleLeft.y + ankleRight.y) / 2;
    double heightInPixels = ankleAverageY - headTop.y;
    return pixelToCentimeters(heightInPixels);
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
