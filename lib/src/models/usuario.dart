import 'dart:convert';
import 'package:asistencia_vial_app/src/models/rol.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  String? id;
  String? usuario;
  String? nombre;
  String? apellido;
  String? telefono;
  String? password;
  String? imagen;
  String? sessionToken;
  List<Rol>? roles=[];



  Usuario({
     this.id,
     this.usuario,
     this.nombre,
     this.apellido,
     this.password,
     this.telefono,
    this.imagen,
    this.sessionToken,
    this.roles,

  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json["Id"],
    usuario: json["Usuario"],
    nombre: json["Nombre"],
    apellido: json["Apellido"],
    telefono: json["Telefono"],
    password: json["Password"],
    imagen: json["Imagen"],
    sessionToken: json["session_token"],
    roles: json["Roles"] == null ? [] : List<Rol>.from(json["Roles"].map((modelo)=>Rol.fromJson(modelo))),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Usuario": usuario,
    "Nombre": nombre,
    "Apellido": apellido,
    "Telefono": telefono,
    "Password": password,
    "Imagen": imagen,
    "session_token": sessionToken,
    "Roles": roles,

  };
}
