
import 'dart:convert';

Boveda bovedaFromJson(String str) => Boveda.fromJson(json.decode(str));

String bovedaToJson(Boveda data) => json.encode(data.toJson());

class Boveda {
  String? id;
  String? fecha;
  String? esactual;
  String? idpeaje;
  String? moneda001;
  String? moneda005;
  String? moneda01;
  String? moneda025;
  String? moneda05;
  String? moneda1;
  String? billete1;
  String? billete2;
  String? billete5;
  String? billete10;
  String? billete20;
  String? observacion;
  String? total;

  Boveda({
     this.id,
     this.fecha,
     this.esactual,
     this.idpeaje,
     this.moneda001,
     this.moneda005,
     this.moneda01,
     this.moneda025,
     this.moneda05,
     this.moneda1,
     this.billete1,
     this.billete2,
     this.billete5,
     this.billete10,
     this.billete20,
     this.observacion,
     this.total,
  });

  factory Boveda.fromJson(Map<String, dynamic> json) => Boveda(
    id: json["Id"],
    fecha: json["Fecha"],
    esactual: json["EsActual"],
    idpeaje: json["IdPeaje"],
    moneda001: json["Moneda_001"],
    moneda005: json["Moneda_005"],
    moneda01: json["Moneda_01"],
    moneda025: json["Moneda_025"],
    moneda05: json["Moneda_05"],
    moneda1: json["Moneda_1"],
    billete1: json["Billete_1"],
    billete2: json["Billete_2"],
    billete5: json["Billete_5"],
    billete10: json["Billete_10"],
    billete20: json["Billete_20"],
    observacion: json["Observacion"],
    total: json["Total"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Fecha": fecha,
    "EsActual": esactual,
    "IdPeaje": idpeaje,
    "Moneda_001": moneda001,
    "Moneda_005": moneda005,
    "Moneda_01": moneda01,
    "Moneda_025": moneda025,
    "Moneda_05": moneda05,
    "Moneda_1": moneda1,
    "Billete_1": billete1,
    "Billete_2": billete2,
    "Billete_5": billete5,
    "Billete_10": billete10,
    "Billete_20": billete20,
    "Observacion": observacion,
    "Total": total,
  };

  static List<Boveda> fromJsonList(List<dynamic> jsonList){
    List<Boveda> toList=[];

    jsonList.forEach((jsonEstado){
      Boveda boveda = Boveda.fromJson(jsonEstado);
      toList.add(boveda);
    });
    return toList;
  }




}
