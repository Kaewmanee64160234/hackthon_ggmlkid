import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart'; // If you're using image_picker to select images

class PoseDetectionService {
  final poseDetector = GoogleMlKit.vision.poseDetector();

  Future<List<Pose>> detectPose(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final List<Pose> poses = await poseDetector.processImage(inputImage);
    return poses;
  }

  void dispose() {
    poseDetector.close();
  }
}
