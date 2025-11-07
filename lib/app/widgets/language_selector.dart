import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/styles.dart';
import '../controllers/home_controller.dart';

// import '../controllers/home_controller.dart';

class LanguageSelector extends GetView<HomeController> {
  LanguageSelector({super.key});
  final List<String> languageCodes = [
    'en-UK',
    'ar-EG',
    'fr',
    'de',
    'es',
    'it',
    'ru',
    'zh',
    'ja',
    'ko',
    'pt',
    'hi',
    'tr',
    'nl',
    'sv',
    'pl',
    'el',
    'he',
    'id',
    'th',
  ];

  final List<String> languageNames = [
    'English',
    'Arabic',
    'French',
    'German',
    'Spanish',
    'Italian',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Portuguese',
    'Hindi',
    'Turkish',
    'Dutch',
    'Swedish',
    'Polish',
    'Greek',
    'Hebrew',
    'Indonesian',
    'Thai',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: GetBuilder<HomeController>(
              id: "from",
              builder: (logic) {
                return DropdownMenu<String>(
                  initialSelection: controller.fromLang,
                  label: const Text("From"),
                  dropdownMenuEntries: List.generate(
                    languageCodes.length,
                    (i) => DropdownMenuEntry(
                      value: languageCodes[i],
                      label: languageNames[i],
                    ),
                  ),
                  onSelected: (v) {
                    if (v != null) controller.fromLang = v;
                  },
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.grey.shade50,
                    ),
                    elevation: const MaterialStatePropertyAll(4),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 0),
          IconButton(
            icon: const Icon(Icons.swap_horiz, size: 28),
            tooltip: "Swap Languages",
            onPressed: () {
              controller.swapLang();
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GetBuilder<HomeController>(
              id: "to",
              builder: (logic) {
                return DropdownMenu<String>(
                  initialSelection: controller.toLang,
                  label: const Text("To"),
                  dropdownMenuEntries: List.generate(
                    languageCodes.length,
                    (i) => DropdownMenuEntry(
                      value: languageCodes[i],
                      label: languageNames[i],
                    ),
                  ),
                  onSelected: (v) {
                    if (v != null) controller.toLang = v;
                  },
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.grey.shade50,
                    ),
                    elevation: const MaterialStatePropertyAll(4),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
