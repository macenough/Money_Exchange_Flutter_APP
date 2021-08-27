// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataListAdapter extends TypeAdapter<DataList> {
  @override
  final int typeId = 0;

  @override
  DataList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataList(
      fields[0] as String?,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentType)
      ..writeByte(1)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
