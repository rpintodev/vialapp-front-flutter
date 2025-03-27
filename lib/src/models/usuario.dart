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
  String? idRol;
  String? idTurno;
  String? turno;
  String? via;
  String? firma;
  String? nombreRol;
  String? nombrePeaje;
  String? idPeaje;
  String? estado;
  String? grupo;
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
    this.idRol,
    this.idTurno,
    this.turno,
    this.via,
    this.firma,
    this.nombreRol,
    this.nombrePeaje,
    this.idPeaje,
    this.estado,
    this.grupo,
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
    idRol: json["IdRol"],
    idTurno: json["IdTurno"],
    turno: json["Turno"],
    via: json["Via"],
    firma: json["Firma"],
    nombreRol: json["NombreRol"],
    nombrePeaje: json["NombrePeaje"],
    idPeaje: json["IdPeaje"],
    estado: json["Estado"],
    grupo: json["Grupo"],
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
    "IdRol": idRol,
    "IdTurno": idTurno,
    "Turno": turno,
    "Via": via,
    "Firma": firma,
    "NombreRol": nombreRol,
    "NombrePeaje": nombrePeaje,
    "IdPeaje": idPeaje,
    "Estado": estado,
    "Grupo": grupo,
    "session_token": sessionToken,
    "Roles": roles,

  };

  static List<Usuario> fromJsonList(List<dynamic> jsonList){
    List<Usuario> toList=[];

    jsonList.forEach((jsonUsuario){
      Usuario usuario = Usuario.fromJson(jsonUsuario);
      toList.add(usuario);
    });
    return toList;
  }

  static List<String> extractDistinctGroups(List<dynamic> jsonList) {
    // Usamos un conjunto para garantizar que los valores sean únicos
    Set<String> uniqueGroups = {};

    jsonList.forEach((jsonUsuario) {
      // Validamos si existe la clave 'Grupo' en el JSON y si no es nula
      if (jsonUsuario.containsKey('Grupo') && jsonUsuario['Grupo'] != null) {
        uniqueGroups.add(jsonUsuario['Grupo'].toString());
      }
    });

    // Convertimos el conjunto en una lista y la devolvemos
    return uniqueGroups.toList();
  }

}
