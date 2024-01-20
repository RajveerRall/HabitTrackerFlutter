import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:habittrackertute/components/month_summary.dart';
import 'package:habittrackertute/components/my_alert_box.dart';
import 'package:habittrackertute/components/time_table_screen.dart';
import 'package:habittrackertute/data/habit_database.dart';
import 'package:habittrackertute/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habittrackertute/components/habit_tile copy.dart';

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
  // Timer? _timer;
  // bool _isTakingScreenshots = false;

  // void toggleScreenshots() {
  //   if (!_isTakingScreenshots) {
  //     startTakingScreenshots(
  //         Duration(seconds: 10)); // Adjust the duration as needed
  //     _isTakingScreenshots = true;
  //   } else {
  //     stopTakingScreenshots();
  //     _isTakingScreenshots = false;
  //   }

  //   setState(() {
  //     _isTakingScreenshots = _isTakingScreenshots;
  //   });
  // }

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
      // Determine the current hour when the habit is added
      int currentHour = DateTime.now().hour;
      // add new habit to todays habit list
      // Add the current hour to the set of hours with habits
      setState(() {
        hoursWithHabits.add(currentHour);
        db.todaysHabitList.add([value, false]);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 350,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: MonthlySummary(
                        datasets: db.heatMapDataSet,
                        startDate: _myBox.get("START_DATE"),
                        selectedDate: (DateTime date) {
                          print('Date selected: $date');
                          taskbydate(date);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 150,
                    child: timeTableScreen!,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white, // Set the color of the container
                  borderRadius: BorderRadius.circular(
                      10), // Set the border radius of the container
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the color of the TextField
                      borderRadius: BorderRadius.circular(
                          15.0), // Set the border radius of the TextField
                    ),
                    child: TextField(
                      onSubmitted: saveNewHabit,
                      controller: _newHabitNameController,
                      cursorColor: Colors.grey[800],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .transparent), // Make the border transparent
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        hintText:
                            'Enter your task here', // Add your hint text here
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: db.todaysHabitList.length,
              itemBuilder: (context, index) {
                int reversedIndex = db.todaysHabitList.length - 1 - index;
                return HabitTile(
                  habitName: db.todaysHabitList[reversedIndex][0],
                  habitCompleted: db.todaysHabitList[reversedIndex][1],
                  onChanged: (value) => checkBoxTapped(value, reversedIndex),
                  settingsTapped: (context) => openHabitSettings(reversedIndex),
                  deleteTapped: (context) => deleteHabit(reversedIndex),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
