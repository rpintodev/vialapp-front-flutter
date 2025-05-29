import 'dart:convert';

Estado estadoFromJson(String str) => Estado.fromJson(json.decode(str));

String estadoToJson(Estado data) => json.encode(data.toJson());

class Estado {
  String id;
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
