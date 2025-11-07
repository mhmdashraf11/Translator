import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/app/pages/home.dart';

import '../controllers/home_controller.dart';

class MatchesList extends GetView<HomeController> {
  const MatchesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Matched Words",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        GetBuilder<HomeController>(
          id: 'matches',
          builder: (logic) => Column(
            children: controller.matches.map((m) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.text_snippet_outlined),
                  title: Text(m['segment'] ?? ''),
                  subtitle: Text(m['translation'] ?? ''),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
