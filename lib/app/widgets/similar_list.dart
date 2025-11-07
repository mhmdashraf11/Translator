import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class SimilarList extends GetView<HomeController> {
  const SimilarList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Similar Translations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        GetBuilder<HomeController>(
          id: 'similars',
          builder: (logic) => Column(
            children: controller.similars.map((s) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(s.fromWord),
                  subtitle: Text(s.toWord),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
