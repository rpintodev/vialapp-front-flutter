// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimiento.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovimientoAdapter extends TypeAdapter<Movimiento> {
  @override
  final int typeId = 2;

  @override
  Movimiento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movimiento(
      id: fields[0] as String?,
      turno: fields[1] as String?,
      idturno: fields[2] as String?,
      idSupervisor: fields[3] as String?,
      nombreSupervisor: fields[4] as String?,
      idCajero: fields[5] as String?,
      nombreCajero: fields[6] as String?,
      idTipoMovimiento: fields[7] as String?,
      nombreMovimiento: fields[8] as String?,
      idPeaje: fields[9] as String?,
      via: fields[10] as String?,
      fecha: fields[11] as String?,
      firmacajero: fields[12] as String?,
      firmasupervisor: fields[13] as String?,
      recibe1C: fields[14] as String?,
      recibe5C: fields[15] as String?,
      recibe10C: fields[16] as String?,
      recibe25C: fields[17] as String?,
      recibe50C: fields[18] as String?,
      recibe1D: fields[19] as String?,
      recibe1DB: fields[20] as String?,
      recibe2D: fields[21] as String?,
      recibe5D: fields[22] as String?,
      recibe10D: fields[23] as String?,
      recibe20D: fields[24] as String?,
      entrega1C: fields[25] as String?,
      entrega5C: fields[26] as String?,
      entrega10C: fields[27] as String?,
      entrega25C: fields[28] as String?,
      entrega50C: fields[29] as String?,
      entrega1D: fields[30] as String?,
      entrega1DB: fields[31] as String?,
      entrega5D: fields[32] as String?,
      entrega10D: fields[33] as String?,
      entrega20D: fields[34] as String?,
      partetrabajo: fields[35] as String?,
      anulaciones: fields[36] as String?,
      valoranulaciones: fields[37] as String?,
      simulaciones: fields[38] as String?,
      valorsimulaciones: fields[39] as String?,
      sobrante: fields[40] as String?,
      estado: fields[41] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Movimiento obj) {
    writer
      ..writeByte(42)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.turno)
      ..writeByte(2)
      ..write(obj.idturno)
      ..writeByte(3)
      ..write(obj.idSupervisor)
      ..writeByte(4)
      ..write(obj.nombreSupervisor)
      ..writeByte(5)
      ..write(obj.idCajero)
      ..writeByte(6)
      ..write(obj.nombreCajero)
      ..writeByte(7)
      ..write(obj.idTipoMovimiento)
      ..writeByte(8)
      ..write(obj.nombreMovimiento)
      ..writeByte(9)
      ..write(obj.idPeaje)
      ..writeByte(10)
      ..write(obj.via)
      ..writeByte(11)
      ..write(obj.fecha)
      ..writeByte(12)
      ..write(obj.firmacajero)
      ..writeByte(13)
      ..write(obj.firmasupervisor)
      ..writeByte(14)
      ..write(obj.recibe1C)
      ..writeByte(15)
      ..write(obj.recibe5C)
      ..writeByte(16)
      ..write(obj.recibe10C)
      ..writeByte(17)
      ..write(obj.recibe25C)
      ..writeByte(18)
      ..write(obj.recibe50C)
      ..writeByte(19)
      ..write(obj.recibe1D)
      ..writeByte(20)
      ..write(obj.recibe1DB)
      ..writeByte(21)
      ..write(obj.recibe2D)
      ..writeByte(22)
      ..write(obj.recibe5D)
      ..writeByte(23)
      ..write(obj.recibe10D)
      ..writeByte(24)
      ..write(obj.recibe20D)
      ..writeByte(25)
      ..write(obj.entrega1C)
      ..writeByte(26)
      ..write(obj.entrega5C)
      ..writeByte(27)
      ..write(obj.entrega10C)
      ..writeByte(28)
      ..write(obj.entrega25C)
      ..writeByte(29)
      ..write(obj.entrega50C)
      ..writeByte(30)
      ..write(obj.entrega1D)
      ..writeByte(31)
      ..write(obj.entrega1DB)
      ..writeByte(32)
      ..write(obj.entrega5D)
      ..writeByte(33)
      ..write(obj.entrega10D)
      ..writeByte(34)
      ..write(obj.entrega20D)
      ..writeByte(35)
      ..write(obj.partetrabajo)
      ..writeByte(36)
      ..write(obj.anulaciones)
      ..writeByte(37)
      ..write(obj.valoranulaciones)
      ..writeByte(38)
      ..write(obj.simulaciones)
      ..writeByte(39)
      ..write(obj.valorsimulaciones)
      ..writeByte(40)
      ..write(obj.sobrante)
      ..writeByte(41)
      ..write(obj.estado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovimientoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
