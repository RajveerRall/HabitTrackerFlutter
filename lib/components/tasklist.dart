import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:habittrackertute/components/habit_tile%20copy.dart';
import 'package:habittrackertute/components/my_alert_box.dart';
import 'package:habittrackertute/data/habit_database.dart';
import 'package:hive/hive.dart';

class Tasklist extends StatefulWidget {
  final List todaysHabitList;
  final HabitDatabase db;
  Tasklist({Key? key, required this.todaysHabitList, required this.db})
      : super(key: key);

  @override
  State<Tasklist> createState() => _TasklistState();
}

class _TasklistState extends State<Tasklist> {
  // Add a new boolean state to track the timer visibility
  bool _showTimer = false;

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index, HabitDatabase db) {
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
      setState(() {
        widget.db.todaysHabitList.add([value, false]);
      });
      widget.db.updateDatabase();
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
  void openHabitSettings(int index, HabitDatabase db, List todaysHabitList) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index, db),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void saveExistingHabit(int index, HabitDatabase db) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  void deleteHabit(int index, HabitDatabase db) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  // Define a method to toggle the timer visibility
  void _toggleTimer() {
    setState(() {
      _showTimer = !_showTimer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 250,
          child: InfoLabel(
            label: 'Enter your task:',
            child: TextBox(
              placeholder: 'Building this app',
              expands: false,
              onSubmitted: saveNewHabit,
              controller: _newHabitNameController,
            ),
          ),
        ),
        Container(
          height: 200,
          width: 500,
          child: ListView.builder(
            shrinkWrap: true,
            physics:
                const BouncingScrollPhysics(), // Adds iOS-like bouncing effect
            itemCount: widget.todaysHabitList.length,
            itemBuilder: (context, index) {
              int reversedIndex = widget.todaysHabitList.length - 1 - index;
              // Provide a default value if the habit name is null
              String habitName = widget.todaysHabitList[reversedIndex][0] ??
                  'Default Habit Name';
              bool? habitCompleted =
                  widget.todaysHabitList[reversedIndex][1] as bool?;
              return HabitTile(
                habitName: habitName,
                habitCompleted: habitCompleted ??
                    false, // Provide a default value for habitCompleted as well
                onChanged: (value) =>
                    checkBoxTapped(value, reversedIndex, widget.db),
                settingsTapped: (context) => openHabitSettings(
                    reversedIndex, widget.db, widget.todaysHabitList),
                deleteTapped: (context) =>
                    deleteHabit(reversedIndex, widget.db),
                onPlayButtonPressed: _toggleTimer,
                expander: const RadioButton(
                  checked: true,
                  onChanged: null,
                ),
              );
            },
            // itemBuilder: (context, index) {
            //   int reversedIndex = widget.todaysHabitList.length - 1 - index;
            //   return HabitTile(
            //     habitName: widget.todaysHabitList[reversedIndex][0],
            //     habitCompleted: widget.todaysHabitList[reversedIndex][1],
            //     onChanged: (value) =>
            //         checkBoxTapped(value, reversedIndex, widget.db),
            //     settingsTapped: (context) => openHabitSettings(
            //         reversedIndex, widget.db, widget.todaysHabitList),
            //     deleteTapped: (context) =>
            //         deleteHabit(reversedIndex, widget.db),
            //     onPlayButtonPressed: _toggleTimer,
            //   );
            // },
          ),
        ),
      ],
    );
  }
}
