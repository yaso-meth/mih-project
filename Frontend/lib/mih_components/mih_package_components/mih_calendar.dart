import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
  late DateTime selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  void onDaySelected(DateTime day, DateTime focusedDay) {
    KenLogger.success("Selected Day: $day");
    setState(() {
      selectedDay = day;
    });
    widget.setDate(selectedDay.toString().split(" ")[0]);
  }

  @override
  void initState() {
    super.initState();
    MihCalendarProvider mihCalendarProvider =
        context.read<MihCalendarProvider>();
    if (mihCalendarProvider.selectedDay.isNotEmpty) {
      selectedDay = DateTime.parse(mihCalendarProvider.selectedDay);
    } else {
      selectedDay = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.calendarWidth,
      child: TableCalendar(
        headerStyle: HeaderStyle(
          formatButtonDecoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          // formatButtonTextStyle:
        ),
        rowHeight: widget.rowHeight,
        focusedDay: selectedDay,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2099, 1, 1),
        onDaySelected: onDaySelected,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayTextStyle: TextStyle(
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          todayDecoration: BoxDecoration(
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          selectedDecoration: BoxDecoration(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(
            color: MihColors.getGreyColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          weekendStyle: TextStyle(
            color: MihColors.getGreyColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
      ),
    );
  }
}
