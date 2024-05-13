import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detection_controller.dart';

class DetectionView extends GetView<DetectionController> {
  const DetectionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Preview'),
      ),
      body: Obx(() {
        // Check if the camera is initialized
        if (controller.isCameraInitialized.isTrue) {
          // Display the camera preview
          return Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: CameraPreview(
                      controller.cameraController!), // Camera preview
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: controller.recognitions?.length ?? 0,
                  itemBuilder: (context, index) {
                    final recognition = controller.recognitions![index];
                    return ListTile(
                      title: Text(
                          "recognition.lable"), // Assuming RecognitionModel has a label
                      subtitle: Text(
                          "Confidence: ${recognition}%"), // Assuming it has a confidence field
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          // Show a loading spinner if the camera is not ready yet
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
