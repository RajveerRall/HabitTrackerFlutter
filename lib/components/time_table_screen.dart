import 'package:flutter/material.dart';
import 'package:habittrackertute/components/timeslot.dart';

// class TimeTableScreen extends StatelessWidget {
//   final Set<int> hoursWithHabits;
//   TimeTableScreen({required this.hoursWithHabits});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Hours',
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//             ),
//             Flexible(
//               child: Row(
//                 children: List.generate(
//                   12,
//                   (index) => TimeSlot(
//                       hour: index + 1,
//                       hasHabit: hoursWithHabits.contains(index + 1)),
//                 ),
//               ),
//             ),
//             Flexible(
//               child: Row(
//                 children: List.generate(
//                   12,
//                   (index) => TimeSlot(
//                       hour: index + 13,
//                       hasHabit: hoursWithHabits.contains(index + 13)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TimeTableScreen extends StatelessWidget {
  final Set<int> hoursWithHabits;
  TimeTableScreen({required this.hoursWithHabits});
  @override
  Widget build(BuildContext context) {
    // ... existing code to build the TimeTableScreen
    // When creating TimeSlot widgets, check if the hour is in hoursWithHabits

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hours',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: List.generate(
                  12,
                  (index) => TimeSlot(
                      hour: index + 1,
                      hasHabit: hoursWithHabits.contains(index + 1))),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: List.generate(
                12,
                (index) => TimeSlot(
                    hour: index + 1,
                    hasHabit: hoursWithHabits.contains(index + 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class TimeTableScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Hourly Time Table'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Flexible(
//               flex: 1,
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: ListView.builder(
//                   itemCount: 12, // 12 hours in a day
//                   itemBuilder: (context, index) {
//                     return TimeSlot(hour: index + 1);
//                   },
//                 ),
//               ),
//             ),
//             Flexible(
//               flex: 1,
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: ListView.builder(
//                   itemCount: 12, // 12 hours in a day
//                   itemBuilder: (context, index) {
//                     return TimeSlot(hour: index + 13);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
