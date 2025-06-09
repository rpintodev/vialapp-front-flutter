// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boveda.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BovedaAdapter extends TypeAdapter<Boveda> {
  @override
  final int typeId = 3;

  @override
  Boveda read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Boveda(
      id: fields[0] as String?,
      fecha: fields[1] as String?,
      esactual: fields[2] as String?,
      idpeaje: fields[3] as String?,
      moneda001: fields[4] as String?,
      moneda005: fields[5] as String?,
      moneda01: fields[6] as String?,
      moneda025: fields[7] as String?,
      moneda05: fields[8] as String?,
      moneda1: fields[9] as String?,
      billete1: fields[10] as String?,
      billete2: fields[11] as String?,
      billete5: fields[12] as String?,
      billete10: fields[13] as String?,
      billete20: fields[14] as String?,
      observacion: fields[15] as String?,
      total: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Boveda obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fecha)
      ..writeByte(2)
      ..write(obj.esactual)
      ..writeByte(3)
      ..write(obj.idpeaje)
      ..writeByte(4)
      ..write(obj.moneda001)
      ..writeByte(5)
      ..write(obj.moneda005)
      ..writeByte(6)
      ..write(obj.moneda01)
      ..writeByte(7)
      ..write(obj.moneda025)
      ..writeByte(8)
      ..write(obj.moneda05)
      ..writeByte(9)
      ..write(obj.moneda1)
      ..writeByte(10)
      ..write(obj.billete1)
      ..writeByte(11)
      ..write(obj.billete2)
      ..writeByte(12)
      ..write(obj.billete5)
      ..writeByte(13)
      ..write(obj.billete10)
      ..writeByte(14)
      ..write(obj.billete20)
      ..writeByte(15)
      ..write(obj.observacion)
      ..writeByte(16)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BovedaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
