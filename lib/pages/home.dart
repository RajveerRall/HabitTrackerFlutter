import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:habittrackertute/components/add_task.dart';
import 'package:habittrackertute/components/month_summary.dart';
import 'package:habittrackertute/components/tasklist.dart';
import 'package:habittrackertute/components/timer_clock.dart';
import 'package:habittrackertute/data/habit_database.dart';
import 'package:habittrackertute/datetime/date_time.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HabitDatabase db = HabitDatabase();
  CircularTimer timer = CircularTimer(duration: Duration(seconds: 10000));
  AddTask addTask = AddTask();
  final _myBox = Hive.box("Habit_Database");
  final _newHabitNameController = TextEditingController();

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
    // timeTableScreen = TimeTableScreen(hoursWithHabits: hoursWithHabits);
  }

  void saveNewHabit(String value) {
    if (value.isNotEmpty) {
      // int currentHour = DateTime.now().hour;
      // add new habit to todays habit list
      // Add the current hour to the set of hours with habits
      setState(() {
        // hoursWithHabits.add(currentHour);
        db.todaysHabitList.add([value, false]);
        // // Rebuild the TimeTableScreen with the updated hoursWithHabits
        // timeTableScreen = TimeTableScreen(hoursWithHabits: hoursWithHabits);
      });

      // clear textfield
      _newHabitNameController.clear();
      // pop dialog box
      // Navigator.of(context).pop();
      db.updateDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.all(16.0),
      header: const PageHeader(
        title: const Text('Timescape'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white, // Set the color of the container
                      ),
                      child: timer,
                    ),
                  ),
                  Container(
                      height: 300,
                      width: 500,
                      child: Tasklist(
                          todaysHabitList: db.todaysHabitList, db: db)),
                ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 350,
                    width: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white, // Set the color of the container
                    ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  void taskbydate(DateTime selectedDate) {
    setState(() {
      db.loadDateData(convertDateTimeToString(selectedDate));
    });
  }
}
