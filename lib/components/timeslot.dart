import 'package:flutter/material.dart';

class TimeSlot extends StatelessWidget {
  final int hour;
  final bool hasHabit;

  TimeSlot({required this.hour, this.hasHabit = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      margin: EdgeInsets.all(2.0),
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: hasHabit ? Color.fromARGB(255, 2, 179, 8) : Colors.grey,
      ),
      child: Center(
        child: Text(
          '$hour',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
// class TimeSlot extends StatelessWidget {
//   final int hour;

//   TimeSlot({required this.hour});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 35,
//       width: 35,
//       margin: EdgeInsets.all(2.0),
//       padding: EdgeInsets.all(2.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color.fromARGB(20, 2, 179, 8),
//             Color.fromARGB(255, 2, 179, 8),
//           ],
//         ),
//       ),
//       child: Center(
//         child: Text(
//           '$hour',
//           style: TextStyle(
//             fontSize: 12.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class TimeSlot extends StatelessWidget {
//   final int hour;

//   TimeSlot({required this.hour});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 35,
//       width: 35,
//       margin: EdgeInsets.all(2.0),
//       padding: EdgeInsets.all(2.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color.fromARGB(255, 202, 226, 199)!,
//             Color.fromARGB(255, 85, 240, 37)!,
//           ],
//         ),
//       ),
//       child: Center(
//         child: Text(
//           '$hour',
//           style: TextStyle(
//             fontSize: 12.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
