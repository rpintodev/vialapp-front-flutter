import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/hive_helper/hive_types.dart';
import 'package:asistencia_vial_app/hive_helper/hive_adapters.dart';
import 'package:asistencia_vial_app/hive_helper/fields/estado_fields.dart';


part 'estado.g.dart';


@HiveType(typeId: HiveTypes.estado, adapterName: HiveAdapters.estado)
class Estado extends HiveObject{
	@HiveField(EstadoFields.id)
  String id;
	@HiveField(EstadoFields.nombre)
  String nombre;

  Estado({
    required this.id,
    required this.nombre,
  });

  factory Estado.fromJson(Map<String, dynamic> json) => Estado(
    id: json["Id"]?.toString() ?? '',
    nombre: json["Nombre"]?.toString() ?? '',
  );

  static List<Estado> fromJsonList(List<dynamic> jsonList){
    List<Estado> toList=[];

    jsonList.forEach((jsonEstado){
      Estado estado = Estado.fromJson(jsonEstado);
      toList.add(estado);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Nombre": nombre,
  };
}