import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:translator/controllers/home_controller.dart';
import 'package:translator/main.dart';
import 'package:translator/app/data/models/translate_entity.dart';
import 'package:translator/app/data/services/translate_service.dart';
import '../controllers/home_controller.dart';
import '../../common/styles.dart';
import '../widgets/history_list.dart';
import '../widgets/input_field.dart';
import '../widgets/language_selector.dart';
import '../widgets/matches_list.dart';
import '../widgets/result_card.dart';
import '../widgets/similar_list.dart';
import '../widgets/translate_button.dart';

class Home extends GetView<HomeController> {
  Home({super.key});

  final _selectedIndex = 0.obs;

  void clearAllHistory() {
    if (!controller.hasHistory) {
      Get.snackbar("Nothing to clear", "Your history is already empty.");
      return;
    }

    Get.defaultDialog(
      title: "Clear All History?",
      middleText: "Are you sure you want to delete all translations?",
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        onPressed: () async {
          await controller.clearAllHistoryData();
          Get.back();
          Get.snackbar(
            "History Cleared",
            "All translations have been removed.",
          );
        },
        child: const Text("Yes, Clear All"),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
    );
  }

  Widget _buildPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        return _buildTranslatorUI(context);
      case 1:
        return _buildHistoryUI();
      default:
        return _buildTranslatorUI(context);
    }
  }

  Widget _buildTranslatorUI(BuildContext context) {
    // final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLanguageSelector(),
            const SizedBox(height: 20),
            _buildInputField(),
            const SizedBox(height: 16),
            _buildTranslateButton(),
            const SizedBox(height: 20),
            _buildResultCard(),
            const SizedBox(height: 24),
            GetBuilder<HomeController>(
              id: 'both',
              builder: (logic) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.matches.isNotEmpty) _buildMatchesList(),
                  if (controller.similars.isNotEmpty) _buildSimilarList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryUI() => HistoryList();

  Widget _buildLanguageSelector() => LanguageSelector();

  Widget _buildInputField() => InputField();

  Widget _buildTranslateButton() => TranslateButton();

  Widget _buildResultCard() => ResultCard();

  Widget _buildMatchesList() => MatchesList();

  Widget _buildSimilarList() => SimilarList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            _selectedIndex.value == 0 ? "Translator" : "History",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(
            () => _selectedIndex.value == 1
                ? IconButton(
                    icon: const Icon(Icons.delete_forever_rounded),
                    tooltip: "Clear All History",
                    onPressed: clearAllHistory,
                  )
                : const SizedBox(),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() => _buildPage(_selectedIndex.value, context)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: (i) => _selectedIndex.value = i,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.translate),
              label: "Translate",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
            ),
          ],
        ),
      ),
    );
  }
}
