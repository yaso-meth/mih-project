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
    );
  }

  @override
  void write(BinaryWriter writer, MIHLoyaltyCard obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.nickname);
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
