import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';

class PatientManagerProvider extends ChangeNotifier {
  int patientProfileIndex;
  int patientManagerIndex;
  bool personalMode;
  Patient? selectedPatient;

  PatientManagerProvider({
    this.patientProfileIndex = 0,
    this.patientManagerIndex = 0,
    this.personalMode = true,
  });

  void reset() {
    patientProfileIndex = 0;
    patientManagerIndex = 0;
    personalMode = true;
    selectedPatient = null;
  }

  void setPatientProfileIndex(int index) {
    patientProfileIndex = index;
    notifyListeners();
  }

  void setPatientManagerIndex(int index) {
    patientManagerIndex = index;
    notifyListeners();
  }

  void setPersonalMode(bool personalMode) {
    this.personalMode = personalMode;
    notifyListeners();
  }

  void setSelectedPatient({required Patient? selectedPatient}) {
    this.selectedPatient = selectedPatient;
    notifyListeners();
  }
}
