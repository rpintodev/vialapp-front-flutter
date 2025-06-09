// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estado.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EstadoAdapter extends TypeAdapter<Estado> {
  @override
  final int typeId = 4;

  @override
  Estado read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Estado(
      id: fields[0] as String,
      nombre: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Estado obj) {
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
      other is EstadoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
