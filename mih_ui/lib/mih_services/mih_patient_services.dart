import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:mzansi_innovation_hub/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_objects/notes.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihPatientServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<Patient?> getPatientDetails(
    String appId,
    PatientManagerProvider patientManagerProvider,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/patients/$appId"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      Patient patient = Patient.fromJson(jsonBody);
      patientManagerProvider.setSelectedPatient(selectedPatient: patient);
      return patient;
    } else {
      return null;
    }
  }

  static Future<List<Patient>> searchPatients(
    PatientManagerProvider patientManagerProvider,
    String search,
  ) async {
    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/patients/search/$search"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Patient> patients =
          List<Patient>.from(l.map((model) => Patient.fromJson(model)));
      patientManagerProvider.setPatientSearchResults(
          patientSearchResults: patients);
      return patients;
    } else {
      throw Exception('failed to load patients');
    }
  }

  Future<int> addPatientService(
    String id_no,
    String fname,
    String lname,
    String email,
    String cell,
    String medAid,
    String medMainMem,
    String medNo,
    String medAidCode,
    String medName,
    String medScheme,
    String address,
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
  ) async {
    var response = await http.post(
      Uri.parse("$baseAPI/patients/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": id_no,
        "first_name": fname,
        "last_name": lname,
        "email": email,
        "cell_no": cell,
        "medical_aid": medAid,
        "medical_aid_main_member": medMainMem,
        "medical_aid_no": medNo,
        "medical_aid_code": medAidCode,
        "medical_aid_name": medName,
        "medical_aid_scheme": medScheme,
        "address": address,
        "app_id": profileProvider.user!.app_id,
      }),
    );
    if (response.statusCode == 201) {
      await getPatientDetails(
          profileProvider.user!.app_id, patientManagerProvider);
      // patientManagerProvider.setSelectedPatient(
      //   selectedPatient: Patient(
      //     idpatients: 0,
      //     id_no: id_no,
      //     first_name: fname,
      //     last_name: lname,
      //     email: email,
      //     cell_no: cell,
      //     medical_aid: medAid,
      //     medical_aid_name: medName,
      //     medical_aid_no: medNo,
      //     medical_aid_main_member: medMainMem,
      //     medical_aid_code: medAidCode,
      //     medical_aid_scheme: medScheme,
      //     address: address,
      //     app_id: profileProvider.user!.app_id,
      //   ),
      // );
    }
    return response.statusCode;
  }

  Future<int> updatePatientService(
    String app_id,
    String id_no,
    String fname,
    String lname,
    String email,
    String cell,
    String medAid,
    String medMainMem,
    String medNo,
    String medAidCode,
    String medName,
    String medScheme,
    String address,
    PatientManagerProvider patientManagerProvider,
  ) async {
    var response = await http.put(
      Uri.parse("$baseAPI/patients/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": id_no,
        "first_name": fname,
        "last_name": lname,
        "email": email,
        "cell_no": cell,
        "medical_aid": medAid,
        "medical_aid_main_member": medMainMem,
        "medical_aid_no": medNo,
        "medical_aid_code": medAidCode,
        "medical_aid_name": medName,
        "medical_aid_scheme": medScheme,
        "address": address,
        "app_id": app_id,
      }),
    );
    if (response.statusCode == 200) {
      await getPatientDetails(app_id, patientManagerProvider);
    }
    return response.statusCode;
  }

  Future<int> getPatientConsultationNotes(
      PatientManagerProvider patientManagerProvider) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/notes/patients/${patientManagerProvider.selectedPatient!.app_id}"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Note> notes =
          List<Note>.from(l.map((model) => Note.fromJson(model)));
      patientManagerProvider.setConsultationNotes(consultationNotes: notes);
    }
    return response.statusCode;
  }

  Future<int> addPatientNoteAPICall(
    String title,
    String noteText,
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notes/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "note_name": title,
        "note_text": noteText,
        "doc_office": profileProvider.business!.Name,
        "doctor":
            "${profileProvider.user!.fname} ${profileProvider.user!.lname}",
        "app_id": patientManagerProvider.selectedPatient!.app_id,
      }),
    );
    if (response.statusCode == 201) {
      await getPatientConsultationNotes(patientManagerProvider);
    }
    return response.statusCode;
  }

  Future<int> deletePatientConsultaionNote(
    int NoteId,
    PatientManagerProvider patientManagerProvider,
  ) async {
    var response = await http.delete(
      Uri.parse("$baseAPI/notes/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"idpatient_notes": NoteId}),
    );
    if (response.statusCode == 201) {
      await getPatientConsultationNotes(patientManagerProvider);
    }
    return response.statusCode;
  }

  Future<int> getPatientDocuments(
      PatientManagerProvider patientManagerProvider) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/patient_files/get/${patientManagerProvider.selectedPatient!.app_id}"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PFile> patientDocuments =
          List<PFile>.from(l.map((model) => PFile.fromJson(model)));
      patientManagerProvider.setPatientDocuments(
          patientDocuments: patientDocuments);
    }
    return response.statusCode;
  }

  Future<int> addPatientFile(
    PlatformFile? file,
    PatientManagerProvider patientManagerProvider,
  ) async {
    var fname = file!.name.replaceAll(RegExp(r' '), '-');
    var filePath =
        "${patientManagerProvider.selectedPatient!.app_id}/patient_files/$fname";
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/patient_files/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "file_path": filePath,
        "file_name": fname,
        "app_id": patientManagerProvider.selectedPatient!.app_id
      }),
    );
    if (response.statusCode == 201) {
      await getPatientDocuments(patientManagerProvider);
    }
    return response.statusCode;
  }

  Future<int> generateMedicalCertificate(
    String startDate,
    String endDate,
    String returnDate,
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
  ) async {
    DateTime now = DateTime.now();
    String fileName =
        "Med-Cert-${patientManagerProvider.selectedPatient!.first_name} ${patientManagerProvider.selectedPatient!.last_name}-${now.toString().substring(0, 19)}.pdf"
            .replaceAll(RegExp(r' '), '-');
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/generate/med-cert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": patientManagerProvider.selectedPatient!.app_id,
        "env": AppEnviroment.getEnv(),
        "patient_full_name":
            "${patientManagerProvider.selectedPatient!.first_name} ${patientManagerProvider.selectedPatient!.last_name}",
        "fileName": fileName,
        "id_no": patientManagerProvider.selectedPatient!.id_no,
        "docfname":
            "DR. ${profileProvider.user!.fname} ${profileProvider.user!.lname}",
        "startDate": startDate,
        "busName": profileProvider.business!.Name,
        "busAddr": "*TO BE ADDED IN THE FUTURE*",
        "busNo": profileProvider.business!.contact_no,
        "busEmail": profileProvider.business!.bus_email,
        "endDate": endDate,
        "returnDate": returnDate,
        "logo_path": profileProvider.business!.logo_path,
        "sig_path": profileProvider.businessUser!.sig_path,
      }),
    );
    if (response.statusCode == 200) {
      var responseAddFiletoDB = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/patient_files/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path":
              "${patientManagerProvider.selectedPatient!.app_id}/patient_files/$fileName",
          "file_name": fileName,
          "app_id": patientManagerProvider.selectedPatient!.app_id
        }),
      );
      if (responseAddFiletoDB.statusCode == 201) {
        await getPatientDocuments(patientManagerProvider);
      }
    }
    return response.statusCode;
  }

  Future<List<PatientAccess>> getPatientAccessListOfBusiness(
    PatientManagerProvider patientManagerProvider,
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/access-requests/business/patient/$business_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PatientAccess> patientAccesses = List<PatientAccess>.from(
          l.map((model) => PatientAccess.fromJson(model)));
      patientManagerProvider.setMyPatientList(myPaitentList: patientAccesses);
      return patientAccesses;
    } else {
      throw Exception('failed to pull patient access List for business');
    }
  }
}
