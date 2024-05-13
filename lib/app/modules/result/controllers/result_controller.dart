import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:hmsmt/app/modules/detection/controllers/detection_controller.dart';

class ResultController extends GetxController {
  //TODO: Implement ResultController

  final count = 0.obs;
  // import detection contr
  final detectionController = Get.find<DetectionController>();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
