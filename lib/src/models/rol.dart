import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/hive_helper/hive_types.dart';
import 'package:asistencia_vial_app/hive_helper/hive_adapters.dart';
import 'package:asistencia_vial_app/hive_helper/fields/rol_fields.dart';


part 'rol.g.dart';


@HiveType(typeId: HiveTypes.rol, adapterName: HiveAdapters.rol)
class Rol extends HiveObject{
	@HiveField(RolFields.id)
  String? id;
	@HiveField(RolFields.nombre)
  String? nombre;
	@HiveField(RolFields.ruta)
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

  String toString() {
    return 'Rol(id: $id, nombre: $nombre)';
  }
}