import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';

class MihCalendarHiveData {
  final Box<List> _personalAppointmentBox =
      Hive.box<List>('personal_calendar_box');
  final Box<List> _businessAppointmentBox =
      Hive.box<List>('business_calendar_box');
  final Box<Map> _modificationsQueue =
      Hive.box<Map>('calendar_modifications_queue');

  Future<void> clearCalendarCache() async {
    try {
      await _personalAppointmentBox.clear();
      await _businessAppointmentBox.clear();
      await _modificationsQueue.clear();
      KenLogger.success("Cleared Local Calendar Cache.");
    } catch (erro) {
      KenLogger.error("Failed to clear local calendar cache.");
    }
  }

  List<Appointment> getCachedPersonalAppointments(String selectedDate) {
    final appointments = _personalAppointmentBox.get(selectedDate);
    if (appointments == null) return [];
    List<Appointment> sortedAppointments = List<Appointment>.from(appointments);
    sortedAppointments.sort((a, b) {
      final dateA = DateTime.parse(a.date_time);
      final dateB = DateTime.parse(b.date_time);
      return dateA.compareTo(dateB);
    });
    return sortedAppointments;
  }

  List<Appointment> getCachedBusinessAppointments(String selectedDate) {
    final appointments = _businessAppointmentBox.get(selectedDate);
    if (appointments == null) return [];
    List<Appointment> sortedAppointments = List<Appointment>.from(appointments);
    sortedAppointments.sort((a, b) {
      final dateA = DateTime.parse(a.date_time);
      final dateB = DateTime.parse(b.date_time);
      return dateA.compareTo(dateB);
    });
    return sortedAppointments;
  }

  Future<void> addAppointmentLocally(Appointment newAppointment) async {
    String date = newAppointment.date_time.split(' ')[0];
    bool isPersonal = newAppointment.app_id != "";
    final String appointmentType = isPersonal ? "Personal" : "Business";
    final Box<List> targetBox =
        isPersonal ? _personalAppointmentBox : _businessAppointmentBox;
    final list = targetBox.get(date) ?? [];
    List<Appointment> sortedAppointments = List<Appointment>.from(list);
    sortedAppointments.add(newAppointment);
    sortedAppointments.sort((a, b) {
      final dateA = DateTime.parse(a.date_time);
      final dateB = DateTime.parse(b.date_time);
      return dateB.compareTo(dateA);
    });
    await targetBox.put(date, sortedAppointments);
    KenLogger.success("New $appointmentType Appointment Saved Locally.");
  }

  Future<void> deleteAppointmentLocally(Appointment deleteAppointment) async {
    String date = deleteAppointment.date_time.split(' ')[0];
    bool isPersonal = deleteAppointment.app_id != "";
    final String appointmentType = isPersonal ? "Personal" : "Business";
    final Box<List> targetBox =
        isPersonal ? _personalAppointmentBox : _businessAppointmentBox;
    final list = targetBox.get(date) ?? [];
    if (list.isEmpty) {
      KenLogger.warning("No local appointments found for $date to delete.");
      return;
    }
    List<Appointment> updatedList = List<Appointment>.from(list);
    updatedList.removeWhere((appointment) =>
        (appointment.offline_id != null &&
            appointment.offline_id == deleteAppointment.offline_id) ||
        (appointment.idappointments == deleteAppointment.idappointments &&
            deleteAppointment.idappointments != 0));
    await targetBox.put(date, updatedList);
    KenLogger.success("$appointmentType Appointment Deleted Locally.");
  }

  Future<void> updateAppointmentLocally(Appointment updatedAppointment) async {
    String date = updatedAppointment.date_time.split(' ')[0];
    bool isPersonal = updatedAppointment.app_id != "";
    final String appointmentType = isPersonal ? "Personal" : "Business";
    final Box<List> targetBox =
        isPersonal ? _personalAppointmentBox : _businessAppointmentBox;
    final list = targetBox.get(date) ?? [];
    if (list.isEmpty) {
      KenLogger.warning("No local appointments found for $date to delete.");
      return;
    }
    List<Appointment> currentAppointments = List<Appointment>.from(list);

    int indexToUpdate = currentAppointments.indexWhere((appointment) =>
        (appointment.offline_id != null &&
            appointment.offline_id == updatedAppointment.offline_id) ||
        appointment.idappointments == updatedAppointment.idappointments);
    if (indexToUpdate != -1) {
      currentAppointments[indexToUpdate] = updatedAppointment;
      currentAppointments.sort((a, b) {
        final dateA = DateTime.parse(a.date_time);
        final dateB = DateTime.parse(b.date_time);
        return dateB.compareTo(dateA);
      });

      await targetBox.put(date, currentAppointments);
      KenLogger.success("$appointmentType Appointment Updated Locally.");
    } else {
      KenLogger.warning(
          "Target appointment not found in local storage for update.");
    }
  }

  Future<void> cachePersonalAppointments(
      String selectedDate, List<Appointment> remotePersonalAppointments) async {
    await _personalAppointmentBox.put(selectedDate, remotePersonalAppointments);
    KenLogger.success("Personal Appointments Cached for $selectedDate");
  }

  Future<void> cacheBusinessAppointments(
      String selectedDate, List<Appointment> remoteBusinessAppointments) async {
    await _businessAppointmentBox.put(selectedDate, remoteBusinessAppointments);
    KenLogger.success("Business Appointments Cached for $selectedDate");
  }

  Future<bool> syncCalendarDataWithServer(
      MzansiProfileProvider profileProvider, String selectedDate) async {
    try {
      List<Appointment> remotePersonalAppointments =
          await MihMzansiCalendarApis.getPersonalAppointmentsV2(
              profileProvider.user!.app_id, selectedDate);
      await cachePersonalAppointments(selectedDate, remotePersonalAppointments);
      if (profileProvider.business != null) {
        List<Appointment> remoteBusinessAppointments =
            await MihMzansiCalendarApis.getBusinessAppointmentsV2(
                profileProvider.business!.business_id, selectedDate);
        await cacheBusinessAppointments(
            selectedDate, remoteBusinessAppointments);
      }
      return true;
    } catch (error) {
      KenLogger.warning(
          "MIH Calender: MIH App Operating in Offline Mode. Sync Paused.");
      return false;
    }
  }

  Future<void> queueAddModification(Appointment newAppointment) async {
    await _modificationsQueue.add({
      'action': 'ADD',
      'payload': newAppointment,
    });
    KenLogger.warning("Add Appointment Queued For Online Sync");
  }

  Future<void> queueDeleteModification(Appointment deleteAppointment) async {
    await _modificationsQueue.add({
      'action': 'DELETE',
      'payload': deleteAppointment,
    });
    KenLogger.warning("Delete Appointment Queued For Online Sync");
  }

  Future<void> queueUpdateModification(Appointment updatedAppointment) async {
    await _modificationsQueue.add({
      'action': 'UPDATE',
      'payload': updatedAppointment,
    });
    KenLogger.warning("Update Appointment Queued For Online Sync");
  }

  Future<bool> processModificationsQueue() async {
    if (_modificationsQueue.isEmpty) {
      return true;
    }
    final List<dynamic> queueKeys = _modificationsQueue.keys.toList();
    for (var taskKey in queueKeys) {
      final task = _modificationsQueue.get(taskKey);
      if (task == null) {
        continue;
      }
      final String action = task['action'];
      final Appointment taskAppointment = task['payload'];
      if (action == 'ADD') {
        dynamic deleteAppointmentTaskKey;
        for (var entry in _modificationsQueue.toMap().entries) {
          if (entry.value['action'] == 'DELETE' &&
              entry.value['payload'].offline_id == taskAppointment.offline_id) {
            deleteAppointmentTaskKey = entry.key;
            break;
          }
        }

        if (deleteAppointmentTaskKey != null) {
          await _modificationsQueue.delete(taskKey);
          await _modificationsQueue.delete(deleteAppointmentTaskKey);
          KenLogger.success(
              "Offline Appointment add & delete cancelled out. Queue cleaned.");
          continue;
        }
        final responseCode =
            await MihMzansiCalendarApis.addAppointment(taskAppointment);

        if (responseCode != null && responseCode == 201) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Local Appointment Added To MIH Cloud");
        } else {
          KenLogger.warning(
              "MIH Calendar: MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
      if (action == 'DELETE') {
        final responseCode =
            await MihMzansiCalendarApis.deleteAppointment(taskAppointment);
        if (responseCode != null && responseCode == 200) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Local Appointment Deleted From MIH Cloud");
        } else {
          KenLogger.warning(
              "MIH Calendar: MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
      if (action == 'UPDATE') {
        final responseCode =
            await MihMzansiCalendarApis.updateAppointment(taskAppointment);
        if (responseCode != null && responseCode == 200) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Local Appointment Updated on MIH Cloud");
        } else {
          KenLogger.warning(
              "MIH Calendar: MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
    }
    return true;
  }

  bool isModificationNotEmpty() {
    return _modificationsQueue.values.toList().isNotEmpty;
  }
}
