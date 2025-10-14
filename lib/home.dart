import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/main.dart';
import 'package:translator/translate_entity.dart';
import 'package:translator/translate_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final translateService = TranslateService();

  final translates = <TranslateEntity>[].obs;
  final similars = <TranslateEntity>[].obs;
  final matches = <Map<String, String>>[].obs;

  final fromController = TextEditingController();
  final toController = TextEditingController();

  final fromLang = 'en-UK'.obs;
  final toLang = 'ar-EG'.obs;
  final translated = ''.obs;
  final isLoading = false.obs;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    translates.value = translateBox.values.toList();
  }

  void clearAllHistory() async {
    if (translates.isEmpty) {
      Get.snackbar(
        "Nothing to clear",
        "Your history is already empty.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.defaultDialog(
      title: "Clear All History?",
      middleText: "Are you sure you want to delete all translations?",
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          await translateBox.clear();
          translates.clear();
          Get.back();
          Get.snackbar(
            "History Cleared",
            "All translations have been removed.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.2),
            colorText: Colors.black87,
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
  Future<void> translate() async {
    final text = fromController.text.trim();

    if (text.isEmpty) {
      translated.value = 'Please enter text to translate.';
      toController.text = translated.value;
      return;
    }

    isLoading.value = true;
    similars.clear();

    // 🔹 Find similar translations (partial matches)
    for (final val in translateBox.values) {
      if (val is TranslateEntity &&
          val.fromlang == fromLang.value &&
          val.tolang == toLang.value) {
        final input = text.toLowerCase();
        final word = val.fromWord.toLowerCase();
        if ((word.contains(input) || input.contains(word)) && word != input) {
          similars.add(val);
          print("✅ Similar found: ${val.fromWord} → ${val.toWord}");
        }
      }
    }

    // 🔹 If translating to the same language → just return the text
    if (fromLang.value == toLang.value) {
      translated.value = text;
      toController.text = text;
      matches.clear();
      isLoading.value = false;
      return;
    }

    // 🔹 Check if translation already exists in local storage
    TranslateEntity? existing;
    for (final val in translateBox.values) {
      if (val is TranslateEntity &&
          val.fromWord.toLowerCase() == text.toLowerCase() &&
          val.fromlang == fromLang.value &&
          val.tolang == toLang.value) {
        existing = val;
        break;
      }
    }

    if (existing != null) {
      translated.value = existing.toWord;
      toController.text = existing.toWord;
      matches.assignAll(existing.matches);
      isLoading.value = false;
      return;
    }

    // 🔹 Call translation service
    final result = await translateService.showTranslate(
      text,
      fromLang.value,
      toLang.value,
    );

    // 🔹 Get matched segments
    final resultMatch = await translateService.showMatches(
      text,
      fromLang.value,
      toLang.value,
    );

    translated.value = result ?? '';
    toController.text = translated.value;

    // 🔹 Convert matches to proper format
    final convertedMatches = resultMatch.map<Map<String, String>>((match) {
      return {
        'segment': match.segment ?? '',
        'translation': match.translation ?? '',
      };
    }).toList();

    matches.assignAll(convertedMatches);

    // 🔹 Save translation locally
    final entity = TranslateEntity(
      fromlang: fromLang.value,
      tolang: toLang.value,
      fromWord: text,
      toWord: translated.value,
      matches: convertedMatches,
    );

    final key = '${fromLang.value}_${toLang.value}_${text.toLowerCase()}';
    await translateBox.put(key, entity);
    translates.add(entity);

    isLoading.value = false;
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildTranslatorUI();
      case 1:
        return _buildHistoryUI();
      default:
        return _buildTranslatorUI();
    }
  }

  Widget _buildTranslatorUI() {
    final theme = Theme.of(context);
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
            _buildTranslateButton(theme),
            const SizedBox(height: 20),
            _buildResultCard(),
            const SizedBox(height: 24),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (matches.isNotEmpty) _buildMatchesList(),
                  if (similars.isNotEmpty) _buildSimilarList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryUI() {
    return Obx(
      () => translates.isEmpty
          ? const Center(
              child: Text(
                "No history yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: translates.length,
              itemBuilder: (context, i) {
                final t = translates[i];
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
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => DropdownMenu<String>(
                initialSelection: fromLang.value,
                label: const Text("From"),
                dropdownMenuEntries: List.generate(
                  languageCodes.length,
                  (i) => DropdownMenuEntry(
                    value: languageCodes[i],
                    label: languageNames[i],
                  ),
                ),
                onSelected: (v) {
                  if (v != null) fromLang.value = v;
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
              ),
            ),
          ),
          const SizedBox(width: 0),
          IconButton(
            icon: const Icon(Icons.swap_horiz, size: 28),
            tooltip: "Swap Languages",
            onPressed: () {
              final temp = fromLang.value;
              fromLang.value = toLang.value;
              toLang.value = temp;
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => DropdownMenu<String>(
                initialSelection: toLang.value,
                label: const Text("To"),
                dropdownMenuEntries: List.generate(
                  languageCodes.length,
                  (i) => DropdownMenuEntry(
                    value: languageCodes[i],
                    label: languageNames[i],
                  ),
                ),
                onSelected: (v) {
                  if (v != null) toLang.value = v;
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade300,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _buildInputField() => Container(
    decoration: _cardDecoration(),
    child: TextField(
      controller: fromController,
      decoration: const InputDecoration(
        labelText: "Enter text",
        hintText: "Type something to translate...",
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16),
      ),
      maxLines: 4,
    ),
  );

  Widget _buildTranslateButton(ThemeData theme) => Obx(
    () => ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: isLoading.value ? null : translate,
      icon: isLoading.value
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.translate, color: Colors.white),
      label: Text(
        isLoading.value ? "Translating..." : "Translate",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );

  Widget _buildResultCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: Obx(
      () => Column(
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
              translated.value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildMatchesList() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Matched Words",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 10),
      Obx(
        () => Column(
          children: matches.map((m) {
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

  Widget _buildSimilarList() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Similar Translations",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 10),
      Obx(
        () => Column(
          children: similars.map((s) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "Translator" : "History",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.delete_forever_rounded),
              tooltip: "Clear All History",
              onPressed: clearAllHistory,
            ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: "Translate",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
    );
  }
}
