import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularTimer extends StatefulWidget {
  final Duration duration;
  // Rename the internal GlobalKey to avoid conflict with Widget.key
  final GlobalKey<CircularTimerState> timerKey =
      GlobalKey<CircularTimerState>();

  @override
  CircularTimerState createState() => CircularTimerState();

  CircularTimer({Key? key, required this.duration}) : super(key: key);

  // Method to stop the timer
  void stopTimer() {
    timerKey.currentState?.stopTimer();
  }

  // Rename the getter to avoid conflict with Widget.key
  GlobalKey<CircularTimerState> get timerGlobalKey => timerKey;

  // Define a static method to access the state's stopTimer method
  static void stopTimerof(GlobalKey<CircularTimerState> key) {
    key.currentState?.stopTimer();
  }
}

class CircularTimerState extends State<CircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  int _elapsedSeconds = 0;
  final GlobalKey<CircularTimerState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60), // Duration for a full circle
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat(); // Restart the animation every minute
      }
    });

    _startTimer();
    _controller.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _controller.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: TimerPainter(progress: _controller.value),
            size: Size(100, 100), // Specify the size of the timer
          ),
          Text(
            _formatDuration(Duration(seconds: _elapsedSeconds)),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

class TimerPainter extends CustomPainter {
  final double progress;

  TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double angle = 2 * 3.14 * progress;
    canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
        -3.14 / 2,
        angle,
        false,
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// class _CircularTimerState extends State<CircularTimer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   Timer? _timer;
//   int _elapsedSeconds = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..repeat(reverse: false);
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _elapsedSeconds++;
//       });
//     });
//   }

//   void stopTimer() {
//     _timer?.cancel();
//     _controller.stop();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         CustomPaint(
//           painter: TimerPainter(progress: _controller.value),
//           size: Size(200, 200), // Specify the size of the timer
//         ),
//         Text(
//           _formatDuration(Duration(seconds: _elapsedSeconds)),
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
// }
