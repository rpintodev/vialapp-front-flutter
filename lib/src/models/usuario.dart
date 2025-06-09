import 'package:asistencia_vial_app/src/models/rol.dart';
import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/hive_helper/hive_types.dart';
import 'package:asistencia_vial_app/hive_helper/hive_adapters.dart';
import 'package:asistencia_vial_app/hive_helper/fields/usuario_fields.dart';


part 'usuario.g.dart';


@HiveType(typeId: HiveTypes.usuario, adapterName: HiveAdapters.usuario)
class Usuario extends HiveObject{
	@HiveField(UsuarioFields.id)
  String? id;
	@HiveField(UsuarioFields.usuario)
  String? usuario;
	@HiveField(UsuarioFields.nombre)
  String? nombre;
	@HiveField(UsuarioFields.apellido)
  String? apellido;
	@HiveField(UsuarioFields.telefono)
  String? telefono;
	@HiveField(UsuarioFields.password)
  String? password;
	@HiveField(UsuarioFields.imagen)
  String? imagen;
	@HiveField(UsuarioFields.sessionToken)
  String? sessionToken;
	@HiveField(UsuarioFields.idRol)
  String? idRol;
	@HiveField(UsuarioFields.idTurno)
  String? idTurno;
	@HiveField(UsuarioFields.turno)
  String? turno;
	@HiveField(UsuarioFields.via)
  String? via;
	@HiveField(UsuarioFields.firma)
  String? firma;
	@HiveField(UsuarioFields.nombreRol)
  String? nombreRol;
	@HiveField(UsuarioFields.nombrePeaje)
  String? nombrePeaje;
	@HiveField(UsuarioFields.idPeaje)
  String? idPeaje;
	@HiveField(UsuarioFields.estado)
  String? estado;
	@HiveField(UsuarioFields.grupo)
  String? grupo;
	@HiveField(UsuarioFields.roles)
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