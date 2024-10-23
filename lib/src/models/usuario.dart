import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  String usuario;
  String nombre;
  String apellido;
  String telefono;
  String password;
  String? imagen;
  int? idRol;
  DateTime? fechaCreacion;
  DateTime? fechaActualizado;

  Usuario({
    required this.usuario,
    required this.nombre,
    required this.apellido,
    required this.password,
    required this.telefono,
    this.imagen,
     this.idRol,
     this.fechaCreacion,
     this.fechaActualizado,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    usuario: json["Usuario"],
    nombre: json["Nombre"],
    apellido: json["Apellido"],
    telefono: json["Telefono"],
    password: json["Password"],
    imagen: json["Imagen"],
    idRol: json["IdRol"],
    fechaCreacion: DateTime.parse(json["Fecha_Creacion"]),
    fechaActualizado: DateTime.parse(json["Fecha_Actualizado"]),
  );

  Map<String, dynamic> toJson() => {
    "Usuario": usuario,
    "Nombre": nombre,
    "Apellido": apellido,
    "Telefono": telefono,
    "Password": password,
    "Imagen": imagen,
    "IdRol": idRol,
    "Fecha_Creacion": fechaCreacion,
    "Fecha_Actualizado": fechaActualizado,
  };
}
