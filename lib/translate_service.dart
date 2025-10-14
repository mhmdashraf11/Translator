// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:translator/translate.dart';
//
// class TranslateService {
//   Future<String> showTranslate(
//     String word,
//     String fromLang,
//     String toLang,
//   ) async {
//     final url =
//         "https://api.mymemory.translated.net/get?q=$word&langpair=$fromLang|$toLang";
//
//     try {
//       final dio = Dio();
//       final resp = await dio.get(url);
//
//       if (resp.statusCode == 200) {
//         final data = resp.data;
//
//         if (data['responseStatus'] == 200) {
//           final translate = translateFromJson(json.encode(data));
//           return translate.responseData.translatedText;
//         } else {
//           throw Exception("API Error: ${data['responseDetails']}");
//         }
//       } else {
//         throw Exception("HTTP Error: ${resp.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Translation failed: $e");
//     }
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:translator/match.dart';
import 'package:translator/translate.dart'; // ملف الموديل

class TranslateService {
  final dio = Dio();
  Future<String?> showTranslate(
    String word,
    String fromLang,
    String toLang,
  ) async {
    final url =
        "https://api.mymemory.translated.net/get?q=$word&langpair=$fromLang|$toLang";
    final resp = await dio.get(url);

    if (resp.statusCode == 200) {
      final Translate data = translateFromJson(json.encode(resp.data));
      if (data.responseStatus == 200) {
        return data.responseData.translatedText;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<MatchResp>> showMatches(
    String word,
    String fromLang,
    String toLang,
  ) async {
    final url =
        "https://api.mymemory.translated.net/get?q=$word&langpair=$fromLang|$toLang";

    final resp = await dio.get(url);

    if (resp.statusCode != 200) return [];

    final data = Translate.fromJson(resp.data);

    if (data.responseStatus != 200) return [];

    final Set<String> seen = {};
    final List<MatchResp> results = [];

    results.add(
      MatchResp(
        segment: word,
        translation: data.responseData.translatedText.trim(),
      ),
    );
    seen.add(data.responseData.translatedText.trim().toLowerCase());

    for (final m in data.matches) {
      final translation = m.translation.trim();
      if (translation.isNotEmpty && !seen.contains(translation.toLowerCase())) {
        results.add(
          MatchResp(segment: m.segment.trim(), translation: translation),
        );
        seen.add(translation.toLowerCase());
      }
    }

    return results;
  }
}
