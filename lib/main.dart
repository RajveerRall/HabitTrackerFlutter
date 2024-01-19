import 'package:flutter/material.dart';
import 'package:habittrackertute/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Habit_Database");
  
  // initialize ffmpeg helper
  WidgetsFlutterBinding.ensureInitialized();
 await FFMpegHelper.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
