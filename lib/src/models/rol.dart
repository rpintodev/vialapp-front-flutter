import 'dart:convert';

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
}