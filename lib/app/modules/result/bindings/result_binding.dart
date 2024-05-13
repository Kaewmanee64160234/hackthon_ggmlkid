import 'package:get/get.dart';
import 'package:hmsmt/app/modules/detection/controllers/detection_controller.dart';

import '../controllers/result_controller.dart';

class ResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultController>(
      () => ResultController(),
    );
    Get.put<DetectionController>(DetectionController());
  }
}
