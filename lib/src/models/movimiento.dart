import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/hive_helper/hive_types.dart';
import 'package:asistencia_vial_app/hive_helper/hive_adapters.dart';
import 'package:asistencia_vial_app/hive_helper/fields/movimiento_fields.dart';


part 'movimiento.g.dart';


@HiveType(typeId: HiveTypes.movimiento, adapterName: HiveAdapters.movimiento)
class Movimiento extends HiveObject{
	@HiveField(MovimientoFields.id)
  String? id;
	@HiveField(MovimientoFields.turno)
  String? turno;
	@HiveField(MovimientoFields.idturno)
  String? idturno;
	@HiveField(MovimientoFields.idSupervisor)
  String? idSupervisor;
	@HiveField(MovimientoFields.nombreSupervisor)
  String? nombreSupervisor;
	@HiveField(MovimientoFields.idCajero)
  String? idCajero;
	@HiveField(MovimientoFields.nombreCajero)
  String? nombreCajero;
	@HiveField(MovimientoFields.idTipoMovimiento)
  String? idTipoMovimiento;
	@HiveField(MovimientoFields.nombreMovimiento)
  String? nombreMovimiento;
	@HiveField(MovimientoFields.idPeaje)
  String? idPeaje;
	@HiveField(MovimientoFields.via)
  String? via;
	@HiveField(MovimientoFields.fecha)
  String? fecha;
	@HiveField(MovimientoFields.firmacajero)
  String? firmacajero;
	@HiveField(MovimientoFields.firmasupervisor)
  String? firmasupervisor;
	@HiveField(MovimientoFields.recibe1C)
  String? recibe1C;
	@HiveField(MovimientoFields.recibe5C)
  String? recibe5C;
	@HiveField(MovimientoFields.recibe10C)
  String? recibe10C;
	@HiveField(MovimientoFields.recibe25C)
  String? recibe25C;
	@HiveField(MovimientoFields.recibe50C)
  String? recibe50C;
	@HiveField(MovimientoFields.recibe1D)
  String? recibe1D;
	@HiveField(MovimientoFields.recibe1DB)
  String? recibe1DB;
	@HiveField(MovimientoFields.recibe2D)
  String? recibe2D;
	@HiveField(MovimientoFields.recibe5D)
  String? recibe5D;
	@HiveField(MovimientoFields.recibe10D)
  String? recibe10D;
	@HiveField(MovimientoFields.recibe20D)
  String? recibe20D;
	@HiveField(MovimientoFields.entrega1C)
  String? entrega1C;
	@HiveField(MovimientoFields.entrega5C)
  String? entrega5C;
	@HiveField(MovimientoFields.entrega10C)
  String? entrega10C;
	@HiveField(MovimientoFields.entrega25C)
  String? entrega25C;
	@HiveField(MovimientoFields.entrega50C)
  String? entrega50C;
	@HiveField(MovimientoFields.entrega1D)
  String? entrega1D;
	@HiveField(MovimientoFields.entrega1DB)
  String? entrega1DB;
	@HiveField(MovimientoFields.entrega5D)
  String? entrega5D;
	@HiveField(MovimientoFields.entrega10D)
  String? entrega10D;
	@HiveField(MovimientoFields.entrega20D)
  String? entrega20D;
	@HiveField(MovimientoFields.partetrabajo)
  String? partetrabajo;
	@HiveField(MovimientoFields.anulaciones)
  String? anulaciones;
	@HiveField(MovimientoFields.valoranulaciones)
  String? valoranulaciones;
	@HiveField(MovimientoFields.simulaciones)
  String? simulaciones;
	@HiveField(MovimientoFields.valorsimulaciones)
  String? valorsimulaciones;
	@HiveField(MovimientoFields.sobrante)
  String? sobrante;
	@HiveField(MovimientoFields.estado)
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

  Map<String, dynamic> toJsonSinId() {
    final data = toJson();
    data.remove('id');
    return data;
  }

}