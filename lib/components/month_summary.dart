import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habittrackertute/datetime/date_time.dart';

class MonthlySummary extends StatefulWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;
  final Function? selectedDate;

  const MonthlySummary(
      {Key? key,
      required this.datasets,
      required this.startDate,
      required this.selectedDate})
      : super(key: key);

  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: HeatMapCalendar(
          // startDate: createDateTimeObject(startDate),
          // endDate: DateTime.now().add(Duration(days: 0)),
          datasets: widget.datasets,
          flexible: true,
          colorMode: ColorMode.color,
          defaultColor: Colors.grey[200],
          textColor: Colors.white,
          showColorTip: true,
          size: 20,
          // showText: true,
          // scrollable: true,

          colorsets: const {
            1: Color.fromARGB(20, 2, 179, 8),
            2: Color.fromARGB(40, 2, 179, 8),
            3: Color.fromARGB(60, 2, 179, 8),
            4: Color.fromARGB(80, 2, 179, 8),
            5: Color.fromARGB(100, 2, 179, 8),
            6: Color.fromARGB(120, 2, 179, 8),
            7: Color.fromARGB(150, 2, 179, 8),
            8: Color.fromARGB(180, 2, 179, 8),
            9: Color.fromARGB(220, 2, 179, 8),
            10: Color.fromARGB(255, 2, 179, 8),
          },
          onClick: (value) {
            widget.selectedDate!(value);
            setState(() {
              _selectedDate = value;
            });
          }),
    );
  }
}
