import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MIHCalendar extends StatefulWidget {
  final double calendarWidth;
  final double rowHeight;
  final void Function(String) setDate;
  const MIHCalendar({
    super.key,
    required this.calendarWidth,
    required this.rowHeight,
    required this.setDate,
  });

  @override
  State<MIHCalendar> createState() => _MIHCalendarState();
}

class _MIHCalendarState extends State<MIHCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Consumer<MihCalendarProvider>(
      builder: (
        BuildContext context,
        MihCalendarProvider calenderProvider,
        Widget? child,
      ) {
        return SizedBox(
          width: widget.calendarWidth,
          child: TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: MihColors.secondary(),
                  ),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              // formatButtonTextStyle:
            ),
            rowHeight: widget.rowHeight,
            focusedDay: DateTime.parse(calenderProvider.selectedDay),
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2999, 1, 1),
            onDaySelected: (day, focusedDay) {
              widget.setDate(day.toString().split(" ")[0]);
            },
            selectedDayPredicate: (day) =>
                isSameDay(day, DateTime.parse(calenderProvider.selectedDay)),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayTextStyle: TextStyle(
                color: MihColors.primary(),
              ),
              todayDecoration: BoxDecoration(
                color: MihColors.green(),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: MihColors.primary(),
              ),
              selectedDecoration: BoxDecoration(
                color: MihColors.secondary(),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: MihColors.grey(),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: MihColors.secondary(),
              ),
              weekendStyle: TextStyle(
                color: MihColors.grey(),
              ),
            ),
          ),
        );
      },
    );
  }
}
