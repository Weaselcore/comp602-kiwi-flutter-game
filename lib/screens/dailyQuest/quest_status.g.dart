// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestStatusAdapter extends TypeAdapter<QuestStatus> {
  @override
  final int typeId = 2;

  @override
  QuestStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestStatus(
      fields[0] as Quest,
      fields[1] as bool,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuestStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._quest)
      ..writeByte(1)
      ..write(obj._isSatisfied)
      ..writeByte(2)
      ..write(obj._isRewardCollected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
