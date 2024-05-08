import 'package:bytenote/pages/note_pages.dart';
import 'package:bytenote/database/database.dart';
import 'package:bytenote/theme/theme.dart';
import 'package:bytenote/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Database.initializeDatabase();
  final Database db = Get.put(Database());
  Get.put(ThemeController());

  db.getNotes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  final ThemeController tc = Get.find();

    return Obx(()=>MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ByteNote',
      theme: tc.theme.value,
      home: NotePage()
    ));
  }
}

