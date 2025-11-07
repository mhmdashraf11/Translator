import 'package:hive/hive.dart';
part 'translate_entity.g.dart';

@HiveType(typeId: 1)
class TranslateEntity {
  @HiveField(1)
  final String fromlang;
  @HiveField(2)
  final String tolang;
  @HiveField(3)
  final String fromWord;
  @HiveField(4)
  final String toWord;
  @HiveField(5)
  List<Map<String, String>> matches;

  TranslateEntity({
    required this.fromlang,
    required this.tolang,
    required this.fromWord,
    required this.toWord,
    required this.matches,
  });
}
