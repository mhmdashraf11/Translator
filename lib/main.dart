import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
import 'package:translator/app/pages/home.dart';
import 'package:translator/app/bindings/home_binding.dart';
import 'package:translator/app/data/models/translate_entity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(const MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TranslateEntityAdapter());
  translateBox = await Hive.openBox<TranslateEntity>('translates');
  // studentBox.clear();
  // final s = Student(studentId: 1, name: 'ahmed', age: 20);
  // studentBox.put(s.studentId, s);
}

late final Box<TranslateEntity> translateBox;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Home(),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => Home(), binding: HomeBinding()),
      ],
    );
  }
}
