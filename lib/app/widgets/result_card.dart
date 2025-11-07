import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/app/pages/home.dart';

import '../../common/styles.dart';
import '../controllers/home_controller.dart';

class ResultCard extends GetView<HomeController> {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: GetBuilder<HomeController>(
        id: 'translate',
        builder: (logic) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Translation Result:",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: Text(
                controller.translated,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
