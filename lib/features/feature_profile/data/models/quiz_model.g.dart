// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizModelAdapter extends TypeAdapter<QuizModel> {
  @override
  final int typeId = 0;

  @override
  QuizModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizModel(
      title: fields[0] as String?,
      date: fields[1] as String?,
      quizPercentages: (fields[3] as List?)?.cast<dynamic>(),
      quizLessons: (fields[2] as List?)?.cast<dynamic>(),
    )
      ..time = fields[4] as String?
      ..type = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, QuizModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.quizLessons)
      ..writeByte(3)
      ..write(obj.quizPercentages)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
