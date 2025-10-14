// To parse this JSON data, do
//
//     final translate = translateFromJson(jsonString);

import 'dart:convert';

Translate translateFromJson(String str) => Translate.fromJson(json.decode(str));

String translateToJson(Translate data) => json.encode(data.toJson());

class Translate {
  final ResponseData responseData;
  final bool quotaFinished;
  final dynamic mtLangSupported;
  final String responseDetails;
  final int responseStatus;
  final dynamic responderId;
  final dynamic exceptionCode;
  final List<Match> matches;

  Translate({
    required this.responseData,
    required this.quotaFinished,
    required this.mtLangSupported,
    required this.responseDetails,
    required this.responseStatus,
    required this.responderId,
    required this.exceptionCode,
    required this.matches,
  });

  Translate copyWith({
    ResponseData? responseData,
    bool? quotaFinished,
    dynamic mtLangSupported,
    String? responseDetails,
    int? responseStatus,
    dynamic responderId,
    dynamic exceptionCode,
    List<Match>? matches,
  }) => Translate(
    responseData: responseData ?? this.responseData,
    quotaFinished: quotaFinished ?? this.quotaFinished,
    mtLangSupported: mtLangSupported ?? this.mtLangSupported,
    responseDetails: responseDetails ?? this.responseDetails,
    responseStatus: responseStatus ?? this.responseStatus,
    responderId: responderId ?? this.responderId,
    exceptionCode: exceptionCode ?? this.exceptionCode,
    matches: matches ?? this.matches,
  );

  factory Translate.fromJson(Map<String, dynamic> json) => Translate(
    responseData: ResponseData.fromJson(json["responseData"]),
    quotaFinished: json["quotaFinished"] ?? false,
    mtLangSupported: json["mtLangSupported"],
    responseDetails: json["responseDetails"],
    responseStatus: (json["responseStatus"] is int)
        ? json["responseStatus"]
        : int.tryParse(json["responseStatus"]?.toString() ?? "0") ?? 0,

    responderId: json["responderId"],
    exceptionCode: json["exception_code"],
    matches: (json["matches"] is List)
        ? List<Match>.from(json["matches"].map((x) => Match.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "responseData": responseData.toJson(),
    "quotaFinished": quotaFinished,
    "mtLangSupported": mtLangSupported,
    "responseDetails": responseDetails,
    "responseStatus": responseStatus,
    "responderId": responderId,
    "exception_code": exceptionCode,
    "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
  };
}

class Match {
  final String id;
  final String segment;
  final String translation;
  final String source;
  final String target;
  final double match;
  final int penalty;

  Match({
    required this.id,
    required this.segment,
    required this.translation,
    required this.source,
    required this.target,
    required this.match,
    required this.penalty,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["id"]?.toString() ?? "",
    segment: json["segment"]?.toString() ?? "",
    translation: json["translation"]?.toString() ?? "",
    source: json["source"]?.toString() ?? "",
    target: json["target"]?.toString() ?? "",
    match: (json["match"] is num)
        ? (json["match"] as num).toDouble()
        : double.tryParse(json["match"]?.toString() ?? "0") ?? 0.0,
    penalty: (json["penalty"] is num)
        ? (json["penalty"] as num).toInt()
        : int.tryParse(json["penalty"]?.toString() ?? "0") ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "segment": segment,
    "translation": translation,
    "source": source,
    "target": target,
    "match": match,
    "penalty": penalty,
  };
}

class ResponseData {
  final String translatedText;
  final double match;

  ResponseData({required this.translatedText, required this.match});

  ResponseData copyWith({String? translatedText, double? match}) =>
      ResponseData(
        translatedText: translatedText ?? this.translatedText,
        match: match ?? this.match,
      );

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    translatedText: json["translatedText"],
    match: (json["match"] is num)
        ? (json["match"] as num).toDouble()
        : double.tryParse(json["match"]?.toString() ?? "0") ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "translatedText": translatedText,
    "match": match,
  };
}
