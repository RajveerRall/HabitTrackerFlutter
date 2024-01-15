import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;
  final Function(BuildContext)? captureTapped;

  const HabitTile(
      {super.key,
      required this.habitName,
      required this.habitCompleted,
      required this.onChanged,
      required this.settingsTapped,
      required this.deleteTapped,
      required this.captureTapped});

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
                // checkbox
                Row(
                  children: [
                    Checkbox(
                      value: habitCompleted,
                      onChanged: onChanged,
                    ),
                    Text(habitName),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => deleteTapped?.call(context),
                      icon: const Icon(Icons.play_arrow_outlined),
                    ),
                    IconButton(
                      onPressed: () => deleteTapped?.call(context),
                      icon: const Icon(Icons.delete_outline),
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
