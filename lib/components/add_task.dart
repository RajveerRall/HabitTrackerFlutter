import 'package:fluent_ui/fluent_ui.dart';
import 'package:habittrackertute/components/my_alert_box.dart';
import 'package:habittrackertute/components/time_table_screen.dart';
import 'package:habittrackertute/data/habit_database.dart';
import 'package:habittrackertute/datetime/date_time.dart';
import 'package:hive/hive.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  TimeTableScreen? timeTableScreen;
  Set<int> hoursWithHabits = {};

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
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Set the color of the TextField
          borderRadius: BorderRadius.circular(
              15.0), // Set the border radius of the TextField
        ),
        child: TextBox(
          onSubmitted: saveNewHabit,
          controller: _newHabitNameController, // Add your hint text here
        ),
      ),
    );
  }
}
