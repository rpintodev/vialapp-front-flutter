// To parse this JSON data, do
//
//     final movimiento = movimientoFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

Movimiento movimientoFromJson(String str) => Movimiento.fromJson(json.decode(str));

String movimientoToJson(Movimiento data) => json.encode(data.toJson());

class Movimiento {
  String? id;
  String? turno;
  String? idturno;
  String? idSupervisor;
  String? nombreSupervisor;
  String? idCajero;
  String? nombreCajero;
  String? idTipoMovimiento;
  String? nombreMovimiento;
  String? idPeaje;
  String? via;
  String? fecha;
  String? firmacajero;
  String? firmasupervisor;
  String? recibe1C;
  String? recibe5C;
  String? recibe10C;
  String? recibe25C;
  String? recibe50C;
  String? recibe1D;
  String? recibe1DB;
  String? recibe2D;
  String? recibe5D;
  String? recibe10D;
  String? recibe20D;
  String? entrega1C;
  String? entrega5C;
  String? entrega10C;
  String? entrega25C;
  String? entrega50C;
  String? entrega1D;
  String? entrega1DB;
  String? entrega5D;
  String? entrega10D;
  String? entrega20D;
  String? partetrabajo;
  String? anulaciones;
  String? valoranulaciones;
  String? simulaciones;
  String? valorsimulaciones;
  String? sobrante;
  String? estado;

  Movimiento({
     this.id,
     this.turno,
     this.idturno,
     this.idSupervisor,
     this.nombreSupervisor,
     this.idCajero,
     this.nombreCajero,
     this.idTipoMovimiento,
     this.nombreMovimiento,
     this.idPeaje,
     this.via,
     this.fecha,
     this.firmacajero,
     this.firmasupervisor,
     this.recibe1C,
     this.recibe5C,
     this.recibe10C,
     this.recibe25C,
     this.recibe50C,
     this.recibe1D,
     this.recibe1DB,
     this.recibe2D,
     this.recibe5D,
     this.recibe10D,
     this.recibe20D,
     this.entrega1C,
     this.entrega5C,
     this.entrega10C,
     this.entrega25C,
     this.entrega50C,
     this.entrega1D,
     this.entrega1DB,
     this.entrega5D,
     this.entrega10D,
     this.entrega20D,
     this.partetrabajo,
     this.anulaciones,
     this.valoranulaciones,
     this.simulaciones,
     this.valorsimulaciones,
     this.sobrante,
    this.estado,
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) => Movimiento(
    id: json["Id"],
    turno: json["Turno"],
    idturno: json["IdTurno"],
    idSupervisor: json["IdSupervisor"],
    nombreSupervisor: json["NombreSupervisor"],
    idCajero: json["IdCajero"],
    nombreCajero: json["NombreCajero"],
    idTipoMovimiento: json["IdTipoMovimiento"],
    nombreMovimiento: json["NombreMovimiento"],
    idPeaje: json["IdPeaje"],
    via: json["Via"],
    fecha: json["Fecha"],
    firmacajero: json["FirmaCajero"],
    firmasupervisor: json["FirmaSupervisor"],
    recibe1C: json["Recibe_1c"],
    recibe5C: json["Recibe_5c"],
    recibe10C: json["Recibe_10c"],
    recibe25C: json["Recibe_25c"],
    recibe50C: json["Recibe_50c"],
    recibe1D: json["Recibe_1d"],
    recibe1DB: json["Recibe_1db"],
    recibe2D: json["Recibe_2d"],
    recibe5D: json["Recibe_5d"],
    recibe10D: json["Recibe_10d"],
    recibe20D: json["Recibe_20d"],
    entrega1C: json["Entrega_1c"],
    entrega5C: json["Entrega_5c"],
    entrega10C: json["Entrega_10c"],
    entrega25C: json["Entrega_25c"],
    entrega50C: json["Entrega_50c"],
    entrega1D: json["Entrega_1d"],
    entrega1DB: json["Entrega_1db"],
    entrega5D: json["Entrega_5d"],
    entrega10D: json["Entrega_10d"],
    entrega20D: json["Entrega_20d"],
    partetrabajo: json["ParteTrabajo"],
    anulaciones: json["Anulaciones"],
    valoranulaciones: json["ValorAnulaciones"],
    simulaciones: json["Simulaciones"],
    valorsimulaciones: json["ValorSimulaciones"],
    sobrante: json["Sobrante"],
    estado: json["Estado"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Turno": turno,
    "IdTurno": idturno,
    "IdSupervisor": idSupervisor,
    "NombreSupervisor": nombreSupervisor,
    "IdCajero": idCajero,
    "NombreCajero": nombreCajero,
    "IdTipoMovimiento": idTipoMovimiento,
    "NombreMovimiento": nombreMovimiento,
    "IdPeaje": idPeaje,
    "Via": via,
    "Fecha": fecha,
    "FirmaCajero": firmacajero,
    "FirmaSupervisor": firmasupervisor,
    "Recibe_1c": recibe1C,
    "Recibe_5c": recibe5C,
    "Recibe_10c": recibe10C,
    "Recibe_25c": recibe25C,
    "Recibe_50c": recibe50C,
    "Recibe_1d": recibe1D,
    "Recibe_1db": recibe1DB,
    "Recibe_2d": recibe2D,
    "Recibe_5d": recibe5D,
    "Recibe_10d": recibe10D,
    "Recibe_20d": recibe20D,
    "Entrega_1c": entrega1C,
    "Entrega_5c": entrega5C,
    "Entrega_10c": entrega10C,
    "Entrega_25c": entrega25C,
    "Entrega_50c": entrega50C,
    "Entrega_1d": entrega1D,
    "Entrega_1db": entrega1DB,
    "Entrega_5d": entrega5D,
    "Entrega_10d": entrega10D,
    "Entrega_20d": entrega20D,
    "ParteTrabajo": partetrabajo,
    "Anulaciones": anulaciones,
    "ValorAnulaciones": valoranulaciones,
    "Simulaciones": simulaciones,
    "ValorSimulaciones": valorsimulaciones,
    "Sobrante": sobrante,
    "Estado": estado,
  };

  static List<Movimiento> fromJsonList(List<dynamic> jsonList){
    List<Movimiento> toList=[];

    jsonList.forEach((jsonMovimiento){
      Movimiento movimiento = Movimiento.fromJson(jsonMovimiento);
      toList.add(movimiento);
    });
    return toList;
  }

}
