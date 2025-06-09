// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rol.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RolAdapter extends TypeAdapter<Rol> {
  @override
  final int typeId = 1;

  @override
  Rol read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rol(
      id: fields[0] as String?,
      nombre: fields[1] as String?,
      ruta: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Rol obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.ruta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
