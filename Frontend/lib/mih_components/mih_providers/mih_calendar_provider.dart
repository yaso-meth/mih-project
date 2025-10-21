import 'package:flutter/foundation.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/appointment.dart';

class MihCalendarProvider extends ChangeNotifier {
  int toolIndex;
  String selectedDay = DateTime.now().toString().split(" ")[0];
  List<Appointment>? personalAppointments;
  List<Appointment>? businessAppointments;

  MihCalendarProvider({
    this.toolIndex = 0,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setSelectedDay(String day) {
    selectedDay = day;
    notifyListeners();
  }

  void resetSelectedDay() {
    selectedDay = DateTime.now().toString().split(" ")[0];
    notifyListeners();
  }

  void setPersonalAppointments({required List<Appointment> appointments}) {
    personalAppointments = appointments;
    notifyListeners();
  }

  void setBusinessAppointments({required List<Appointment> appointments}) {
    businessAppointments = appointments;
    notifyListeners();
  }

  void addPersonalAppointment({required Appointment newAppointment}) {
    personalAppointments?.add(newAppointment);
    notifyListeners();
  }

  void addBusinessAppointment({required Appointment newAppointment}) {
    businessAppointments?.add(newAppointment);
    notifyListeners();
  }

  void editPersonalAppointment({required Appointment updatedAppointment}) {
    int index = personalAppointments?.indexWhere((appointment) =>
            appointment.idappointments == updatedAppointment.idappointments) ??
        -1;
    if (index != -1) {
      personalAppointments?[index] = updatedAppointment;
      notifyListeners();
    }
  }

  void editBusinessAppointment({required Appointment updatedAppointment}) {
    int index = businessAppointments?.indexWhere((appointment) =>
            appointment.idappointments == updatedAppointment.idappointments) ??
        -1;
    if (index != -1) {
      businessAppointments?[index] = updatedAppointment;
      notifyListeners();
    }
  }

  void deletePersonalAppointment({required int appointmentId}) {
    personalAppointments?.removeWhere(
        (appointment) => appointment.idappointments == appointmentId);
    notifyListeners();
  }

  void deleteBusinessAppointment({required int appointmentId}) {
    businessAppointments?.removeWhere(
        (appointment) => appointment.idappointments == appointmentId);
    notifyListeners();
  }
}
