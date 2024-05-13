import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraService {
  CameraController? cameraController; // No longer 'late'
  ResolutionPreset resolutionPreset = ResolutionPreset.high;

  Future<void> initializeCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(cameras.first, resolutionPreset);
      await cameraController!.initialize();
    } else {
      throw Exception("No cameras available");
    }
  }

  void dispose() {
    cameraController?.dispose();
  }

  void startImageStream(Function(InputImage) onImage) {
    cameraController!.startImageStream((cameraImage) {
      onImage(getInputImageFromCameraImage(cameraImage, cameraController!));
    });
  }

  InputImage getInputImageFromCameraImage(
      CameraImage cameraImage, CameraController cameraController) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
    final InputImageRotation rotation =
        rotationFromDegrees(cameraController.description.sensorOrientation);

    // Assuming all planes have the same bytes per row for simplicity
    final int bytesPerRow = cameraImage.planes.first.bytesPerRow;

    final InputImageMetadata metadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: InputImageFormat.nv21,
      bytesPerRow: bytesPerRow, // Add this line
      // : cameraImage.planes.map((Plane plane) {
      //   return InputImagePlaneMetadata(
      //     bytesPerRow: plane.bytesPerRow,
      //     height: plane.height,
      //     width: plane.width,
      //   );
      // }).toList(),
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  InputImageRotation rotationFromDegrees(int degrees) {
    switch (degrees) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<XFile> takePicture() async {
    if (!cameraController!.value.isInitialized) {
      throw Exception('Camera is not initialized');
    }
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return Future.error('Capture is already pending');
    }
    try {
      XFile file = await cameraController!.takePicture();
      return file;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
