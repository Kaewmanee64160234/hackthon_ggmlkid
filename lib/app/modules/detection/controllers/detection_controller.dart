import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:hmsmt/app/data/types/RecognitionModel.dart';

class DetectionController extends GetxController {
  //TODO: Implement DetectionController
  var isCameraInitialized = false.obs;
  CameraController? cameraController;
  var isDetecting = false.obs;
  List<RecognitionModel>? recognitions;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController
        ?.dispose(); // Ensure the camera is disposed when the controller is closed
    super.onClose();
  }

  void initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(cameras[0], ResolutionPreset.high);
        await cameraController!.initialize();
        isCameraInitialized.value = true; // Use observable for UI updates
      } else {
        print("No available cameras");
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }
}
