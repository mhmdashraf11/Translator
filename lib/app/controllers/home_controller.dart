import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/app/data/models/translate_entity.dart';
import 'package:translator/app/data/services/translate_service.dart';

import '../../main.dart';

// import '../main.dart';

class HomeController extends GetxController {
  final translateService = TranslateService();

  var translates = <TranslateEntity>[];
  final similars = <TranslateEntity>[];
  final matches = <Map<String, String>>[];

  final fromController = TextEditingController();
  final toController = TextEditingController();

  var fromLang = 'en-UK';
  var toLang = 'ar-EG';
  var translated = '';
  var isLoading = false;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    fromController.dispose();
    toController.dispose();

    super.onClose();
  }

  void loadData() {
    translates = translateBox.values.toList();
    update(['translates']);
  }

  void swapLang() {
    final temp = fromLang;
    fromLang = toLang;
    toLang = temp;
    update(['from', 'to']);
  }

  void fireTranslate() {
    isLoading ? null : translate();
    update(['loading']);
  }

  Future<void> clearAllHistoryData() async {
    await translateBox.clear();
    translates.clear();
    update(['translates']);
  }

  bool get hasHistory => translates.isNotEmpty;

  Future<void> translate() async {
    final text = fromController.text.trim();

    if (text.isEmpty) {
      translated = 'Please enter text to translate.';
      toController.text = translated;
      update(['to']);
      update(['translate']);
      return;
    }

    isLoading = true;
    update(['loading']);
    similars.clear();
    update(['similars', 'both']);

    // 🔹 Find similar translations (partial matches)
    for (final val in translateBox.values) {
      if (val is TranslateEntity &&
          val.fromlang == fromLang &&
          val.tolang == toLang) {
        final input = text.toLowerCase();
        final word = val.fromWord.toLowerCase();
        if ((word.contains(input) || input.contains(word)) && word != input) {
          similars.add(val);
          update(['similars', 'both']);
        }
      }
    }

    // 🔹 If translating to the same language → just return the text
    if (fromLang == toLang) {
      translated = text;
      toController.text = text;
      matches.clear();
      isLoading = false;
      update(['loading', 'to', 'translate', 'matches', 'both']);
      return;
    }

    final lookupKey = '${fromLang}_${toLang}_${text.toLowerCase()}';
    final existing = translateBox.get(lookupKey);

    if (existing != null) {
      translated = existing.toWord;
      toController.text = existing.toWord;
      matches.assignAll(existing.matches);
      isLoading = false;
      update(['loading', 'to', 'translate', 'matches', 'both']);
      return;
    }

    // 🔹 Call translation service
    final result = await translateService.showTranslate(text, fromLang, toLang);

    // 🔹 Get matched segments
    final resultMatch = await translateService.showMatches(
      text,
      fromLang,
      toLang,
    );

    translated = result ?? '';
    toController.text = translated;
    update(['to', 'translate']);

    // 🔹 Convert matches to proper format
    final convertedMatches = resultMatch.map<Map<String, String>>((match) {
      return {
        'segment': match.segment ?? '',
        'translation': match.translation ?? '',
      };
    }).toList();

    matches.assignAll(convertedMatches);
    update(['matches', 'both']);

    // 🔹 Save translation locally
    final entity = TranslateEntity(
      fromlang: fromLang,
      tolang: toLang,
      fromWord: text,
      toWord: translated,
      matches: convertedMatches,
    );

    final key = '${fromLang}_${toLang}_${text.toLowerCase()}';
    await translateBox.put(key, entity);
    translates.add(entity);

    isLoading = false;
    update(['loading']);
  }
}
