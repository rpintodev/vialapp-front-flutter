import 'dart:convert';

import 'package:asistencia_vial_app/main.dart';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  String? id;
  String? nombre;
  String? ruta;

  Rol({
     this.id,
     this.nombre,
     this.ruta,
  });

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
    id: json["Id"],
    nombre: json["Nombre"],
    ruta: json["Ruta"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Nombre": nombre,
    "Ruta": ruta,
  };

  static List<Rol> fromJsonList(List<dynamic> jsonList){
    List<Rol> toList=[];

    jsonList.forEach((jsonRol){
      Rol rol = Rol.fromJson(jsonRol);
      toList.add(rol);
    });
    return toList;
  }

  @override
  String toString() {
    return 'Rol(id: $id, nombre: $nombre)';
  }
}