import 'dart:convert';

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


  Usuario({
     this.id,
     this.usuario,
     this.nombre,
     this.apellido,
     this.password,
     this.telefono,
    this.imagen,
    this.sessionToken,

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


  };
}
