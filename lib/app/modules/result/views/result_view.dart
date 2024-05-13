import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../controllers/result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detection Result")),
      body: Obx(() => buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    var poses = controller.detectionController.detectedPoses;
    var imagePath = controller.detectionController.imagePath.value;

    if (poses.isEmpty) {
      return Center(child: Text("No poses detected"));
    } else {
      return Column(
        children: [
          Expanded(
            child: FutureBuilder<ui.Image>(
              future: loadImage(File(imagePath)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return CustomPaint(
                    painter: PosePainter(image: snapshot.data!, poses: poses),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Text("Detected Poses: ${controller.detectionController.height} cm"),
          // Optional: Display calculated height or other pose-related data
        ],
      );
    }
  }

  Future<ui.Image> loadImage(File imageFile) async {
    final data = await imageFile.readAsBytes();
    // Resize image if necessary here before decoding
    return await decodeImageFromList(data);
  }
}

class PosePainter extends CustomPainter {
  final ui.Image image;
  final List<Pose> poses;

  PosePainter({required this.image, required this.poses});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image
    final paint = Paint();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image,
        fit: BoxFit.fill);

    // Calculate scale factors
    final double scaleX = size.width / image.width;
    final double scaleY = size.height / image.height;

    // Paint setup for landmarks
    final landmarkPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    // Draw landmarks adjusted for image scale
    for (var pose in poses) {
      for (var landmark in pose.landmarks.values) {
        // Apply scale factors to landmark positions
        final dx = landmark.x * scaleX;
        final dy = landmark.y * scaleY;
        canvas.drawCircle(Offset(dx, dy), 5, landmarkPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FullWidthImagePainter extends CustomPainter {
  final ui.Image image;

  FullWidthImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image to fill the width
    paintImage(
      canvas: canvas,
      image: image,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      fit: BoxFit.fitWidth, // Adjust the image to fit the width of the canvas
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FullWidthImageCanvas extends StatelessWidget {
  final ui.Image image;

  FullWidthImageCanvas(this.image);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FullWidthImagePainter(image),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height, // Set height as needed
      ),
    );
  }
}
