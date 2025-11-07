import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../app/controllers/home_controller.dart';
import '../controllers/home_controller.dart';
// import '../controllers/home_controller.dart';

class HistoryList extends GetView<HomeController> {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'translates',
      builder: (logic) => controller.translates.isEmpty
          ? const Center(
              child: Text(
                "No history yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.translates.length,
              itemBuilder: (context, i) {
                final t = controller.translates[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.history, color: Colors.blue),
                    title: Text(
                      t.fromWord,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(t.toWord),
                  ),
                );
              },
            ),
    );
    ;
  }
}
