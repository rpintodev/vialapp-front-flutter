// To parse this JSON data, do
//
//     final turno = turnoFromJson(jsonString);

import 'dart:convert';

Turno turnoFromJson(String str) => Turno.fromJson(json.decode(str));

String turnoToJson(Turno data) => json.encode(data.toJson());

class Turno {
  String? id;
  String? idSupervisor;
  String? idCajero;
  String? estado;
  String? sessionToken;

  Turno({
     this.id,
     this.idSupervisor,
     this.idCajero,
     this.estado,
    this.sessionToken,
  });

  factory Turno.fromJson(Map<String, dynamic> json) => Turno(
    id: json["Id"],
    idSupervisor: json["IdSupervisor"],
    idCajero: json["IdCajero"],
    estado: json["Estado"],
      sessionToken: json["session_token"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "IdSupervisor": idSupervisor,
    "IdCajero": idCajero,
    "Estado": estado,
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
