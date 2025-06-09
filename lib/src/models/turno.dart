import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/hive_helper/hive_types.dart';
import 'package:asistencia_vial_app/hive_helper/hive_adapters.dart';
import 'package:asistencia_vial_app/hive_helper/fields/turno_fields.dart';


part 'turno.g.dart';


@HiveType(typeId: HiveTypes.turno, adapterName: HiveAdapters.turno)
class Turno extends HiveObject{
	@HiveField(TurnoFields.id)
  String? id;
	@HiveField(TurnoFields.idSupervisor)
  String? idSupervisor;
	@HiveField(TurnoFields.idCajero)
  String? idCajero;
	@HiveField(TurnoFields.estado)
  String? estado;
	@HiveField(TurnoFields.via)
  String? via;
	@HiveField(TurnoFields.sessionToken)
  String? sessionToken;

  Turno({
     this.id,
     this.idSupervisor,
     this.idCajero,
     this.estado,
     this.via,
    this.sessionToken,
  });

  factory Turno.fromJson(Map<String, dynamic> json) => Turno(
    id: json["Id"],
    idSupervisor: json["IdSupervisor"],
    idCajero: json["IdCajero"],
    estado: json["Estado"],
    via: json["Via"],
      sessionToken: json["session_token"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "IdSupervisor": idSupervisor,
    "IdCajero": idCajero,
    "Estado": estado,
    "Via": via,
    "session_token": sessionToken,

  };

  static List<Turno> fromJsonList(List<dynamic> jsonList){
    List<Turno> toList=[];

    jsonList.forEach((jsonTurno){
      Turno turno = Turno.fromJson(jsonTurno);
      toList.add(turno);
    });
    return toList;
  }
}