import 'dart:convert';

Peaje peajeFromJson(String str) => Peaje.fromJson(json.decode(str));

String peajeToJson(Peaje data) => json.encode(data.toJson());

class Peaje {
  String id;
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
