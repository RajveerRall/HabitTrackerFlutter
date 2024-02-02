// import 'package:flutter/material.dart';
// import 'package:habittrackertute/pages/home.dart';
// import 'package:habittrackertute/pages/home_page.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:ffmpeg_helper/ffmpeg_helper.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:desktop_window/desktop_window.dart';
// import 'package:flutter_acrylic/flutter_acrylic.dart';
// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';

// import 'package:flutter_acrylic/flutter_acrylic.dart';
// import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';

// Future<void> main() async {
//   // initialize hive
//   await Hive.initFlutter();

//   // open a box
//   await Hive.openBox("Habit_Database");

//   // window transparent
//   WidgetsFlutterBinding.ensureInitialized();
//   await Window.initialize();
//   await Window.setEffect(
//     effect: WindowEffect.acrylic,
//     color: const Color(0xCC222222),
//   );
//   appWindow
//     ..minSize = Size(940, 560)
//     ..size = Size(720, 540)
//     ..alignment = Alignment.center
//     ..show();

//   doWhenWindowReady(() {
//     appWindow.show();
//   });

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           backgroundColor: Colors.transparent),
//       home: HomePage(),
//     );
//   }
// }

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:habittrackertute/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Habit_Database");
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // window transparent
  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.acrylic,
    color: const Color(0xCC222222),
  );

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Timescape');
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    // await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setSize(const Size(955, 545));
    await windowManager.setMinimumSize(const Size(955, 545));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Timescape',
      theme: FluentThemeData(
        acrylicBackgroundColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      // theme:
      //     ThemeData(brightness: Brightness.light, accentColor: Colors.orange),
      // darkTheme:
      //     ThemeData(brightness: Brightness.dark, accentColor: Colors.orange),
      home: const MyHomePage(title: 'Timescape'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  int index = 0;
  final viewKey = GlobalKey();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      key: viewKey,
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() {
          index = i;
        }),
        displayMode: PaneDisplayMode.compact,
        items: [
          PaneItem(
            icon: Icon(FluentIcons.home),
            body: Home(),
          ),
          PaneItem(
            icon: Icon(FluentIcons.clock),
            body: Home(),
          )
        ],
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
          context: context,
          builder: (_) {
            return ContentDialog(
                title: const Text('Confirm close'),
                content: const Text('Are you sure want to close the app?'),
                actions: [
                  FilledButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.pop(context);
                      windowManager.destroy();
                    },
                  ),
                  FilledButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]);
          });
    }
  }
}

class _selectedIndex {}
