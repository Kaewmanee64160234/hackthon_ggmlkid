import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Height Measurement")),
        // goto detection view
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.offAndToNamed('/detection');
          },
          child: Icon(Icons.camera),
        ),
        body: Center(
          child: Text("Camera is loading..."),
        ));
  }
}
