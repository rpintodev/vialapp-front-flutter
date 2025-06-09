import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/hive_helper/hive_types.dart';
import 'package:asistencia_vial_app/hive_helper/hive_adapters.dart';
import 'package:asistencia_vial_app/hive_helper/fields/peaje_fields.dart';


part 'peaje.g.dart';


@HiveType(typeId: HiveTypes.peaje, adapterName: HiveAdapters.peaje)
class Peaje extends HiveObject{
	@HiveField(PeajeFields.id)
  String id;
	@HiveField(PeajeFields.nombre)
  String nombre;

  Peaje({
    required this.id,
    required this.nombre,
  });

  factory Peaje.fromJson(Map<String, dynamic> json) => Peaje(
    id: json["Id"],
    nombre: json["Nombre"],
  );

  static List<Peaje> fromJsonList(List<dynamic> jsonList){
    List<Peaje> toList=[];

    jsonList.forEach((jsonPeaje){
      Peaje peaje = Peaje.fromJson(jsonPeaje);
      toList.add(peaje);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Nombre": nombre,
  };
}