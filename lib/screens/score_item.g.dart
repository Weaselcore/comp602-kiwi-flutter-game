// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreItemAdapter extends TypeAdapter<ScoreItem> {
  @override
  final int typeId = 0;

  @override
  ScoreItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreItem(
      fields[1] as String,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.userNm)
      ..writeByte(2)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
