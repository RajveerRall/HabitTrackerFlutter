import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:path/path.dart' as path;

class HabitTile extends StatefulWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  _HabitTileState createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  int count = 0;
  Timer? _timer;
  bool _isTakingScreenshots = false;
  int selectedValue = 3;

  void toggleScreenshots() {
    if (!_isTakingScreenshots) {
      startTakingScreenshots(Duration(seconds: 10), widget.habitName);
      _isTakingScreenshots = true;
    } else {
      stopTakingScreenshots();
      _isTakingScreenshots = false;
    }

    setState(() {
      _isTakingScreenshots = _isTakingScreenshots;
    });
  }

  void startTakingScreenshots(Duration interval, String habitName) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (Timer t) {
      takeScreenshot(habitName, count);
      count++;
    });
  }

  Future<void> takeScreenshot(String habitName, int count) async {
    final directory = await getApplicationDocumentsDirectory();
    final habitDirectory = Directory(path.join(directory.path, habitName));
    await habitDirectory.create(recursive: true);
    final DateTime now = DateTime.now();
    final String formattedNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final imagePath =
        path.join(habitDirectory.path, '$habitName-$count-$formattedNow.png');
    await ScreenCapturer.instance.capture(
      mode: CaptureMode.screen,
      imagePath: imagePath,
      silent: true,
    );
    print('Screenshot saved to $imagePath');
  }

  Future<void> stopTakingScreenshots() async {
    _timer?.cancel();
    print('Stopped taking screenshots');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 580,
            height: 80,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: widget.habitCompleted,
                      onChanged: widget.onChanged,
                    ),
                    Text(widget.habitName),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: toggleScreenshots,
                      icon: Icon(
                          _isTakingScreenshots ? Icons.stop : Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: () => widget.deleteTapped?.call(context),
                      icon: const Icon(Icons.delete_outline),
                    ),
                    DropdownButton<int>(
                      value: selectedValue,
                      items: const [
                        DropdownMenuItem(child: Text('1 Minutes'), value: 1),
                        DropdownMenuItem(child: Text('3 Minutes'), value: 3),
                        DropdownMenuItem(child: Text('5 Minutes'), value: 5),
                        DropdownMenuItem(child: Text('7 Minutes'), value: 7),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                          var duration = Duration(minutes: value);
                          startTakingScreenshots(duration, widget.habitName);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}






// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screen_capturer/screen_capturer.dart';
// import 'package:path/path.dart' as path;
// import 'package:windows_notification/notification_message.dart';
// import 'package:windows_notification/windows_notification.dart';
// import 'package:uuid/uuid.dart';

// class HabitTile extends StatefulWidget {
//   final String habitName;
//   final bool habitCompleted;
//   final Function(bool?)? onChanged;
//   final Function(BuildContext)? settingsTapped;
//   final Function(BuildContext)? deleteTapped;

//   const HabitTile({
//     super.key,
//     required this.habitName,
//     required this.habitCompleted,
//     required this.onChanged,
//     required this.settingsTapped,
//     required this.deleteTapped,
//   });

//   @override
//   _HabitTileState createState() => _HabitTileState();
// }

// class _HabitTileState extends State<HabitTile> {
//   int count = 0;
//   Timer? _timer;
//   bool _isTakingScreenshots = false;
//   int selectedValue = 3;
//   late final String appId;
//   late final WindowsNotification _winNotifyPlugin;

//   _HabitTileState() {
//     var uuid = Uuid();
//     appId = uuid.v1();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _winNotifyPlugin = WindowsNotification(applicationId: appId);
//   }

//   NotificationMessage message = NotificationMessage.fromPluginTemplate(
//       "test1", "Title", "Body",
//       largeImage: "D:/Users/admin/Documents/hjk/hjk-9-2024-01-18 22:51:12.png",
//       image: "D:/Users/admin/Documents/hjk/hjk-9-2024-01-18 22:51:12.png");

//   void toggleScreenshots() {
//     if (!_isTakingScreenshots) {
//       startTakingScreenshots(Duration(seconds: 10),
//           widget.habitName); // Adjust the duration as needed
//       _isTakingScreenshots = true;
//       _winNotifyPlugin.showNotificationPluginTemplate(message);
//     } else {
//       stopTakingScreenshots();
//       _isTakingScreenshots = false;
//     }

//     setState(() {
//       _isTakingScreenshots = _isTakingScreenshots;
//     });
//   }

//   void startTakingScreenshots(Duration interval, String habitName) {
//     _timer?.cancel(); // Cancel any previous timer
//     _timer = Timer.periodic(interval, (Timer t) {
//       takeScreenshot(habitName, count);
//       count++;
//     });
//   }

//   Future<void> takeScreenshot(String habitName, int count) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final habitDirectory = Directory(path.join(directory.path, habitName));
//     await habitDirectory.create(recursive: true);
//     final DateTime now = DateTime.now();
//     final String formattedNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     final imagePath =
//         path.join(habitDirectory.path, '$habitName-$count-$formattedNow.png');
//     await ScreenCapturer.instance.capture(
//       mode: CaptureMode.screen,
//       imagePath: imagePath,
//       silent: true,
//     );
//     print('Screenshot saved to $imagePath');
//   }

//   Future<void> stopTakingScreenshots() async {
//     _timer?.cancel(); // Stop taking screenshots
//     print('Stopped taking screenshots');
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Container(
//             width: 580,
//             height: 80,
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // checkbox
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: widget.habitCompleted,
//                       onChanged: widget.onChanged,
//                     ),
//                     Text(widget.habitName),
//                   ],
//                 ),

//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: toggleScreenshots,
//                       icon: Icon(
//                           _isTakingScreenshots ? Icons.stop : Icons.play_arrow),
//                     ),
//                     IconButton(
//                       onPressed: () => widget.deleteTapped?.call(context),
//                       icon: const Icon(Icons.delete_outline),
//                     ),
//                     // Expanded(
//                     //   flex: 1,
//                     //   child: TextField(
//                     //     onSubmitted: (value) {
//                     //       var duration = Duration(seconds: int.parse(value));
//                     //       onIntervalSet(duration);
//                     //     },
//                     //     keyboardType: TextInputType.number,
//                     //     decoration: const InputDecoration(
//                     //       labelText: 'Interval (in seconds)',
//                     //     ),
//                     //   ),
//                     // ),
//                     DropdownButton<int>(
//                       value:
//                           selectedValue, // Set the value to the state variable
//                       items: const [
//                         DropdownMenuItem(child: Text('1 Minutes'), value: 1),
//                         DropdownMenuItem(child: Text('3 Minutes'), value: 3),
//                         DropdownMenuItem(child: Text('5 Minutes'), value: 5),
//                         DropdownMenuItem(child: Text('7 Minutes'), value: 7),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           selectedValue = value!;
//                           var duration = Duration(minutes: value);
//                           startTakingScreenshots(duration,
//                               widget.habitName); // Schedule the notification
//                         });
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
