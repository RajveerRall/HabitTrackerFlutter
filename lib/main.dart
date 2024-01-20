import 'package:flutter/material.dart';
import 'package:habittrackertute/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';

Future<void> main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Habit_Database");

  // window transparent
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.acrylic,
    color: const Color(0xCC222222),
  );
  appWindow
    ..minSize = Size(640, 360)
    ..size = Size(720, 540)
    ..alignment = Alignment.center
    ..show();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.transparent),
      home: HomePage(),
    );
  }
}
