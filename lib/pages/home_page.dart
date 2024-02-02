import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:habittrackertute/components/month_summary.dart';
import 'package:habittrackertute/components/my_alert_box.dart';
import 'package:habittrackertute/components/time_table_screen.dart';
import 'package:habittrackertute/components/timer_clock.dart';
import 'package:habittrackertute/data/habit_database.dart';
import 'package:habittrackertute/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habittrackertute/components/habit_tile copy.dart';
import 'package:habittrackertute/components/timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int count = 0;
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  TimeTableScreen? timeTableScreen;
  Set<int> hoursWithHabits = {};
  final GlobalKey<CircularTimerState> timerKey =
      GlobalKey<CircularTimerState>();

  // Add a new boolean state to track the timer visibility
  bool _showTimer = false;

  CircularTimer timer = CircularTimer(duration: Duration(seconds: 10));

  // Define a method to toggle the timer visibility
  void _toggleTimer() {
    setState(() {
      _showTimer = !_showTimer;
    });
  }

  @override
  void initState() {
    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    // there already exists data, this is not the first time
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();
    timeTableScreen = TimeTableScreen(hoursWithHabits: hoursWithHabits);
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // create a new habit
  final _newHabitNameController = TextEditingController();

  // save new habit
  void saveNewHabit(String value) {
    if (value.isNotEmpty) {
      int currentHour = DateTime.now().hour;
      // add new habit to todays habit list
      // Add the current hour to the set of hours with habits
      setState(() {
        hoursWithHabits.add(currentHour);
        db.todaysHabitList.add([value, false]);
        // Rebuild the TimeTableScreen with the updated hoursWithHabits
        timeTableScreen = TimeTableScreen(hoursWithHabits: hoursWithHabits);
      });

      // clear textfield
      _newHabitNameController.clear();
      // pop dialog box
      // Navigator.of(context).pop();
      db.updateDatabase();
    }
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

// task link when you click on calendar
  void taskbydate(DateTime selectedDate) {
    setState(() {
      db.loadDateData(convertDateTimeToString(selectedDate));
    });
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: const Text('Timescape', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: [],
      ),
      backgroundColor: Colors.transparent,
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularTimer(
                    key: timerKey,
                    duration: Duration(seconds: 10)), // Your timer widget
                ElevatedButton(
                  onPressed: () {
                    CircularTimer.stopTimerof(
                        timerKey); // Call the stopTimer method();
                  },
                  child: Text('Stop Timer'),
                ),
              ],
            ),
            Container(
              height: 200,
              width: 500, // Define a fixed height for the container
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    const BouncingScrollPhysics(), // Adds iOS-like bouncing effect
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  int reversedIndex = db.todaysHabitList.length - 1 - index;
                  String habitName = db.todaysHabitList[reversedIndex][0] ??
                      'Default Habit Name';
                  bool habitCompleted =
                      db.todaysHabitList[reversedIndex][1] ?? false;

                  return HabitTile(
                    habitName: habitName,
                    habitCompleted: habitCompleted,
                    onChanged: (value) => checkBoxTapped(value, reversedIndex),
                    settingsTapped: (context) =>
                        openHabitSettings(reversedIndex),
                    deleteTapped: (context) => deleteHabit(reversedIndex),
                    onPlayButtonPressed: _toggleTimer,
                  );
                },
              ),
            ),
          ],
        ),

        // Expanded(
        //   flex: 2,
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: Container(
        //             height: 60,
        //             width: 250,
        //             decoration: BoxDecoration(
        //               color: Colors.white, // Set the color of the container
        //               borderRadius: BorderRadius.circular(
        //                   10), // Set the border radius of the container
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.all(9.0),
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   color: Colors.white, // Set the color of the TextField
        //                   borderRadius: BorderRadius.circular(
        //                       15.0), // Set the border radius of the TextField
        //                 ),
        //                 child: TextField(
        //                   onSubmitted: saveNewHabit,
        //                   controller: _newHabitNameController,
        //                   cursorColor: Colors.grey[800],
        //                   decoration: const InputDecoration(
        //                     contentPadding: EdgeInsets.all(10),
        //                     border: OutlineInputBorder(
        //                       borderSide: BorderSide(
        //                           color: Colors
        //                               .transparent), // Make the border transparent
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(15.0)),
        //                     ),
        //                     hintText:
        //                         'Enter your task here', // Add your hint text here
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         ListView.builder(
        //           shrinkWrap: true,
        //           physics: const ScrollPhysics(),
        //           itemCount: db.todaysHabitList.length,
        //           itemBuilder: (context, index) {
        //             int reversedIndex = db.todaysHabitList.length - 1 - index;
        //             String habitName = db.todaysHabitList[reversedIndex][0] ??
        //                 'Default Habit Name';
        //             bool habitCompleted =
        //                 db.todaysHabitList[reversedIndex][1] ?? false;

        //             // final habitData = db.todaysHabitList[index];
        //             return HabitTile(
        //               habitName: habitName,
        //               habitCompleted: habitCompleted,
        //               onChanged: (value) =>
        //                   checkBoxTapped(value, reversedIndex),
        //               settingsTapped: (context) =>
        //                   openHabitSettings(reversedIndex),
        //               deleteTapped: (context) => deleteHabit(reversedIndex),
        //               onPlayButtonPressed: _toggleTimer,
        //             );
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Column(
                    children: [
                      MonthlySummary(
                        datasets: db.heatMapDataSet,
                        startDate: _myBox.get("START_DATE"),
                        selectedDate: (DateTime date) {
                          print('Date selected: $date');
                          taskbydate(date);
                        },
                      ),
                      Expanded(
                        flex: 2,
                        // Adjust the flex factor as needed for layout
                        child: Container(
                            height: 250,
                            width: 250,
                            child: TimeTableScreen(
                                hoursWithHabits: hoursWithHabits)),
                      ),
                      if (_showTimer) // This line checks if _showTimer is true
                        TimerWidget(
                            initialTime: 1), // Place your TimerWidget here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
