// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalContactAdapter extends TypeAdapter<LocalContact> {
  @override
  final int typeId = 1;

  @override
  LocalContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalContact(
      name: fields[0] as String?,
      photoUri: fields[1] as String,
      customerHash: fields[2] as String,
      mobile: fields[3] as String?,
      vpa: fields[4] as String,
      upiNumber8: fields[5] as String,
      upiNumber9: fields[6] as String,
      upiNumber: fields[7] as String,
      isBlocked: fields[8] as bool,
      isRegistered: fields[9] as bool,
      isSynced: fields[10] as bool,
      action: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalContact obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.photoUri)
      ..writeByte(2)
      ..write(obj.customerHash)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.vpa)
      ..writeByte(5)
      ..write(obj.upiNumber8)
      ..writeByte(6)
      ..write(obj.upiNumber9)
      ..writeByte(7)
      ..write(obj.upiNumber)
      ..writeByte(8)
      ..write(obj.isBlocked)
      ..writeByte(9)
      ..write(obj.isRegistered)
      ..writeByte(10)
      ..write(obj.isSynced)
      ..writeByte(11)
      ..write(obj.action);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
