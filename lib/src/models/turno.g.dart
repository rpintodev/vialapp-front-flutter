// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turno.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TurnoAdapter extends TypeAdapter<Turno> {
  @override
  final int typeId = 6;

  @override
  Turno read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Turno(
      id: fields[0] as String?,
      idSupervisor: fields[1] as String?,
      idCajero: fields[2] as String?,
      estado: fields[3] as String?,
      via: fields[4] as String?,
      sessionToken: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Turno obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idSupervisor)
      ..writeByte(2)
      ..write(obj.idCajero)
      ..writeByte(3)
      ..write(obj.estado)
      ..writeByte(4)
      ..write(obj.via)
      ..writeByte(5)
      ..write(obj.sessionToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TurnoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
