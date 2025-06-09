// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 0;

  @override
  Usuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usuario(
      id: fields[0] as String?,
      usuario: fields[1] as String?,
      nombre: fields[2] as String?,
      apellido: fields[3] as String?,
      password: fields[5] as String?,
      telefono: fields[4] as String?,
      imagen: fields[6] as String?,
      sessionToken: fields[7] as String?,
      idRol: fields[8] as String?,
      idTurno: fields[9] as String?,
      turno: fields[10] as String?,
      via: fields[11] as String?,
      firma: fields[12] as String?,
      nombreRol: fields[13] as String?,
      nombrePeaje: fields[14] as String?,
      idPeaje: fields[15] as String?,
      estado: fields[16] as String?,
      grupo: fields[17] as String?,
      roles: (fields[18] as List?)?.cast<Rol>(),
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.usuario)
      ..writeByte(2)
      ..write(obj.nombre)
      ..writeByte(3)
      ..write(obj.apellido)
      ..writeByte(4)
      ..write(obj.telefono)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.imagen)
      ..writeByte(7)
      ..write(obj.sessionToken)
      ..writeByte(8)
      ..write(obj.idRol)
      ..writeByte(9)
      ..write(obj.idTurno)
      ..writeByte(10)
      ..write(obj.turno)
      ..writeByte(11)
      ..write(obj.via)
      ..writeByte(12)
      ..write(obj.firma)
      ..writeByte(13)
      ..write(obj.nombreRol)
      ..writeByte(14)
      ..write(obj.nombrePeaje)
      ..writeByte(15)
      ..write(obj.idPeaje)
      ..writeByte(16)
      ..write(obj.estado)
      ..writeByte(17)
      ..write(obj.grupo)
      ..writeByte(18)
      ..write(obj.roles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
