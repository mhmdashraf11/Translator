// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslateEntityAdapter extends TypeAdapter<TranslateEntity> {
  @override
  final int typeId = 1;

  @override
  TranslateEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateEntity(
      fromlang: fields[1] as String,
      tolang: fields[2] as String,
      fromWord: fields[3] as String,
      toWord: fields[4] as String,
      matches: (fields[5] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, TranslateEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.fromlang)
      ..writeByte(2)
      ..write(obj.tolang)
      ..writeByte(3)
      ..write(obj.fromWord)
      ..writeByte(4)
      ..write(obj.toWord)
      ..writeByte(5)
      ..write(obj.matches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
