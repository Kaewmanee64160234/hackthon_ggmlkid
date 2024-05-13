import 'package:get/get.dart';

import '../modules/detection/bindings/detection_binding.dart';
import '../modules/detection/views/detection_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/result/bindings/result_binding.dart';
import '../modules/result/views/result_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETECTION,
      page: () => const DetectionView(),
      binding: DetectionBinding(),
    ),
    GetPage(
      name: _Paths.RESULT,
      page: () => ResultView(),
      binding: ResultBinding(),
    ),
  ];
}
