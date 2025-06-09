// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peaje.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeajeAdapter extends TypeAdapter<Peaje> {
  @override
  final int typeId = 5;

  @override
  Peaje read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Peaje(
      id: fields[0] as String,
      nombre: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Peaje obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeajeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
