import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String? id;
  String? nombre;
  String? ruta;


  ResponseApi({
    this.id,
    this.nombre,
    this.ruta,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
    id: json["Id"],
    nombre: json["Nombre"],
    ruta: json["Ruta"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Nombre": nombre,
    "Ruta": ruta,
  };
}