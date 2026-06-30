import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';

class MihCalendarHiveData {
  final Box<Appointment> _personalAppointmentBox =
      Hive.box<Appointment>('personal_calendar_box');
  final Box<Appointment> _businessAppointmentBox =
      Hive.box<Appointment>('business_calendar_box');

  List<Appointment> getCachedPersonalAppointments() {
    final appointments = _personalAppointmentBox.values.toList();
    appointments.sort((a, b) {
      final dateA = DateTime.parse(a.date_time);
      final dateB = DateTime.parse(b.date_time);
      return dateB.compareTo(dateA);
    });
    return appointments;
  }

  List<Appointment> getCachedBusinessAppointments() {
    final appointments = _businessAppointmentBox.values.toList();
    appointments.sort((a, b) {
      final dateA = DateTime.parse(a.date_time);
      final dateB = DateTime.parse(b.date_time);
      return dateB.compareTo(dateA);
    });
    return appointments;
  }

  Future<bool> syncCalendarDataWithServer() async {
    return false;
  }
}
