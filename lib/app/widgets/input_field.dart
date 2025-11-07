import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:translator/controllers/home_controller.dart';

import '../../common/styles.dart';

import '../controllers/home_controller.dart';

class InputField extends GetView<HomeController> {
  const InputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(),
      child: TextField(
        controller: controller.fromController,
        decoration: const InputDecoration(
          labelText: "Enter text",
          hintText: "Type something to translate...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 4,
      ),
    );
  }
}
