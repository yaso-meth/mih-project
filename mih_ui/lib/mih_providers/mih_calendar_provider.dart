import 'package:flutter/foundation.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/mih_calendar_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';

class MihCalendarProvider extends ChangeNotifier {
  final MihCalendarHiveData _hiveData;
  int toolIndex;
  String selectedDay = DateTime.now().toString().split(" ")[0];
  List<Appointment>? personalAppointments;
  List<Appointment>? businessAppointments;

  MihCalendarProvider(
    this._hiveData, {
    this.toolIndex = 0,
  }) {
    loadCachedCalendar();
  }

  void loadCachedCalendar() {
    personalAppointments = _hiveData.getCachedPersonalAppointments(selectedDay);
    businessAppointments = _hiveData.getCachedBusinessAppointments(selectedDay);
    KenLogger.success("Calendars Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData(
      MzansiProfileProvider profileProvider) async {
    await _hiveData.processModificationsQueue();
    bool success = await _hiveData.syncCalendarDataWithServer(
        profileProvider, selectedDay);
    loadCachedCalendar();
    return success;
  }

  Future<void> addNewAppointmentLocally(
    MzansiProfileProvider profileProvider,
    Appointment newAppointment,
  ) async {
    String date = newAppointment.date_time.split(' ')[0];
    await _hiveData.addAppointmentLocally(newAppointment);
    await _hiveData.queueAddModification(newAppointment);
    await _hiveData.processModificationsQueue();
    await _hiveData.syncCalendarDataWithServer(
      profileProvider,
      date,
    );
    loadCachedCalendar();
  }

  Future<void> deleteAppointmentLocally(
    MzansiProfileProvider profileProvider,
    Appointment deleteAppointment,
  ) async {
    String date = deleteAppointment.date_time.split(' ')[0];
    await _hiveData.deleteAppointmentLocally(deleteAppointment);
    await _hiveData.queueDeleteModification(deleteAppointment);
    await _hiveData.processModificationsQueue();
    await _hiveData.syncCalendarDataWithServer(
      profileProvider,
      date,
    );
    loadCachedCalendar();
  }

  Future<void> updateAppointmentLocally(
    MzansiProfileProvider profileProvider,
    Appointment updatedAppointment,
  ) async {
    String date = updatedAppointment.date_time.split(' ')[0];
    await _hiveData.updateAppointmentLocally(updatedAppointment);
    await _hiveData.queueUpdateModification(updatedAppointment);
    await _hiveData.processModificationsQueue();
    await _hiveData.syncCalendarDataWithServer(
      profileProvider,
      date,
    );
    loadCachedCalendar();
  }

  bool isLocalModificationsPending() {
    return _hiveData.isModificationNotEmpty();
  }

  Future<void> clearCalendarCacheAndProvider() async {
    await _hiveData.clearCalendarCache();
    reset();
  }

  void reset() {
    toolIndex = 0;
    personalAppointments = null;
    businessAppointments = null;
    notifyListeners();
  }

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
    KenLogger.success("Edit Patient Index: $index");
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
