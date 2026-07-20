// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final typeId = 0;

  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUser(
      (fields[0] as num).toInt(),
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idUser)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.fname)
      ..writeByte(3)
      ..write(obj.lname)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.app_id)
      ..writeByte(6)
      ..write(obj.username)
      ..writeByte(7)
      ..write(obj.pro_pic_path)
      ..writeByte(8)
      ..write(obj.purpose);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusinessAdapter extends TypeAdapter<Business> {
  @override
  final typeId = 1;

  @override
  Business read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Business(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
      fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Business obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.business_id)
      ..writeByte(1)
      ..write(obj.Name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.registration_no)
      ..writeByte(4)
      ..write(obj.logo_name)
      ..writeByte(5)
      ..write(obj.logo_path)
      ..writeByte(6)
      ..write(obj.contact_no)
      ..writeByte(7)
      ..write(obj.bus_email)
      ..writeByte(8)
      ..write(obj.app_id)
      ..writeByte(9)
      ..write(obj.gps_location)
      ..writeByte(10)
      ..write(obj.practice_no)
      ..writeByte(11)
      ..write(obj.vat_no)
      ..writeByte(12)
      ..write(obj.website)
      ..writeByte(13)
      ..write(obj.rating)
      ..writeByte(14)
      ..write(obj.mission_vision);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusinessUserAdapter extends TypeAdapter<BusinessUser> {
  @override
  final typeId = 2;

  @override
  BusinessUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessUser(
      (fields[0] as num).toInt(),
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessUser obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.idbusiness_users)
      ..writeByte(1)
      ..write(obj.business_id)
      ..writeByte(2)
      ..write(obj.app_id)
      ..writeByte(3)
      ..write(obj.signature)
      ..writeByte(4)
      ..write(obj.sig_path)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.access);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserConsentAdapter extends TypeAdapter<UserConsent> {
  @override
  final typeId = 3;

  @override
  UserConsent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserConsent(
      app_id: fields[0] as String,
      privacy_policy_accepted: fields[1] as DateTime,
      terms_of_services_accepted: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserConsent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.app_id)
      ..writeByte(1)
      ..write(obj.privacy_policy_accepted)
      ..writeByte(2)
      ..write(obj.terms_of_services_accepted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserConsentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileLinkAdapter extends TypeAdapter<ProfileLink> {
  @override
  final typeId = 4;

  @override
  ProfileLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileLink(
      idprofile_links: (fields[0] as num).toInt(),
      app_id: fields[1] as String,
      business_id: fields[2] as String,
      site_name: fields[3] as String,
      custom_name: fields[4] as String,
      destination: fields[5] as String,
      order: (fields[6] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ProfileLink obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.idprofile_links)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.business_id)
      ..writeByte(3)
      ..write(obj.site_name)
      ..writeByte(4)
      ..write(obj.custom_name)
      ..writeByte(5)
      ..write(obj.destination)
      ..writeByte(6)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusinessEmployeeAdapter extends TypeAdapter<BusinessEmployee> {
  @override
  final typeId = 5;

  @override
  BusinessEmployee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessEmployee(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessEmployee obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.business_id)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.access)
      ..writeByte(4)
      ..write(obj.fname)
      ..writeByte(5)
      ..write(obj.lname)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.username);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessEmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MIHLoyaltyCardAdapter extends TypeAdapter<MIHLoyaltyCard> {
  @override
  final typeId = 6;

  @override
  MIHLoyaltyCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MIHLoyaltyCard(
      idloyalty_cards: (fields[0] as num).toInt(),
      app_id: fields[1] as String,
      shop_name: fields[2] as String,
      card_number: fields[3] as String,
      favourite: fields[4] as String,
      priority_index: (fields[5] as num).toInt(),
      nickname: fields[6] as String,
      offline_id: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MIHLoyaltyCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idloyalty_cards)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.shop_name)
      ..writeByte(3)
      ..write(obj.card_number)
      ..writeByte(4)
      ..write(obj.favourite)
      ..writeByte(5)
      ..write(obj.priority_index)
      ..writeByte(6)
      ..write(obj.nickname)
      ..writeByte(7)
      ..write(obj.offline_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MIHLoyaltyCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppointmentAdapter extends TypeAdapter<Appointment> {
  @override
  final typeId = 7;

  @override
  Appointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointment(
      idappointments: (fields[0] as num).toInt(),
      app_id: fields[1] as String,
      business_id: fields[2] as String,
      date_time: fields[3] as String,
      title: fields[4] as String,
      description: fields[5] as String,
      offline_id: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Appointment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.idappointments)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.business_id)
      ..writeByte(3)
      ..write(obj.date_time)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.offline_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookmarkedBusinessAdapter extends TypeAdapter<BookmarkedBusiness> {
  @override
  final typeId = 9;

  @override
  BookmarkedBusiness read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkedBusiness(
      idbookmarked_businesses: (fields[0] as num).toInt(),
      app_id: fields[1] as String,
      business_id: fields[2] as String,
      business_name: fields[3] as String,
      created_date: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkedBusiness obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idbookmarked_businesses)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.business_id)
      ..writeByte(3)
      ..write(obj.business_name)
      ..writeByte(4)
      ..write(obj.created_date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkedBusinessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MinesweeperPlayerScoreAdapter
    extends TypeAdapter<MinesweeperPlayerScore> {
  @override
  final typeId = 10;

  @override
  MinesweeperPlayerScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinesweeperPlayerScore(
      app_id: fields[0] as String,
      username: fields[1] as String,
      proPicUrl: fields[2] as String,
      difficulty: fields[3] as String,
      game_time: fields[4] as String,
      game_score: (fields[5] as num).toDouble(),
      played_date: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MinesweeperPlayerScore obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.app_id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.proPicUrl)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.game_time)
      ..writeByte(5)
      ..write(obj.game_score)
      ..writeByte(6)
      ..write(obj.played_date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinesweeperPlayerScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PatientAccessAdapter extends TypeAdapter<PatientAccess> {
  @override
  final typeId = 11;

  @override
  PatientAccess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientAccess(
      business_id: fields[0] as String,
      business_name: fields[1] as String,
      app_id: fields[2] as String,
      fname: fields[3] as String,
      lname: fields[4] as String,
      id_no: fields[5] as String,
      type: fields[6] as String,
      status: fields[7] as String,
      approved_by: fields[8] as String,
      approved_on: fields[9] as String,
      requested_by: fields[10] as String,
      requested_on: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PatientAccess obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.business_id)
      ..writeByte(1)
      ..write(obj.business_name)
      ..writeByte(2)
      ..write(obj.app_id)
      ..writeByte(3)
      ..write(obj.fname)
      ..writeByte(4)
      ..write(obj.lname)
      ..writeByte(5)
      ..write(obj.id_no)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.approved_by)
      ..writeByte(9)
      ..write(obj.approved_on)
      ..writeByte(10)
      ..write(obj.requested_by)
      ..writeByte(11)
      ..write(obj.requested_on);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAccessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 12;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      idpatient_notes: (fields[0] as num).toInt(),
      note_name: fields[1] as String,
      note_text: fields[2] as String,
      insert_date: fields[3] as String,
      doc_office: fields[4] as String,
      doctor: fields[5] as String,
      app_id: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.idpatient_notes)
      ..writeByte(1)
      ..write(obj.note_name)
      ..writeByte(2)
      ..write(obj.note_text)
      ..writeByte(3)
      ..write(obj.insert_date)
      ..writeByte(4)
      ..write(obj.doc_office)
      ..writeByte(5)
      ..write(obj.doctor)
      ..writeByte(6)
      ..write(obj.app_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PFileAdapter extends TypeAdapter<PFile> {
  @override
  final typeId = 13;

  @override
  PFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PFile(
      (fields[0] as num).toInt(),
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PFile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idpatient_files)
      ..writeByte(1)
      ..write(obj.file_path)
      ..writeByte(2)
      ..write(obj.file_name)
      ..writeByte(3)
      ..write(obj.insert_date)
      ..writeByte(4)
      ..write(obj.app_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClaimStatementFileAdapter extends TypeAdapter<ClaimStatementFile> {
  @override
  final typeId = 14;

  @override
  ClaimStatementFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClaimStatementFile(
      idclaim_statement_file: (fields[0] as num).toInt(),
      app_id: fields[1] as String,
      business_id: fields[2] as String,
      insert_date: fields[3] as String,
      file_path: fields[4] as String,
      file_name: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClaimStatementFile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idclaim_statement_file)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.business_id)
      ..writeByte(3)
      ..write(obj.insert_date)
      ..writeByte(4)
      ..write(obj.file_path)
      ..writeByte(5)
      ..write(obj.file_name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClaimStatementFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final typeId = 15;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      idpatients: (fields[0] as num).toInt(),
      id_no: fields[1] as String,
      first_name: fields[2] as String,
      last_name: fields[3] as String,
      email: fields[4] as String,
      cell_no: fields[5] as String,
      medical_aid: fields[6] as String,
      medical_aid_name: fields[7] as String,
      medical_aid_no: fields[8] as String,
      medical_aid_main_member: fields[9] as String,
      medical_aid_code: fields[10] as String,
      medical_aid_scheme: fields[11] as String,
      address: fields[12] as String,
      app_id: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.idpatients)
      ..writeByte(1)
      ..write(obj.id_no)
      ..writeByte(2)
      ..write(obj.first_name)
      ..writeByte(3)
      ..write(obj.last_name)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.cell_no)
      ..writeByte(6)
      ..write(obj.medical_aid)
      ..writeByte(7)
      ..write(obj.medical_aid_name)
      ..writeByte(8)
      ..write(obj.medical_aid_no)
      ..writeByte(9)
      ..write(obj.medical_aid_main_member)
      ..writeByte(10)
      ..write(obj.medical_aid_code)
      ..writeByte(11)
      ..write(obj.medical_aid_scheme)
      ..writeByte(12)
      ..write(obj.address)
      ..writeByte(13)
      ..write(obj.app_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
