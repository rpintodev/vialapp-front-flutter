import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../environment/environment.dart';
import '../models/boveda.dart';
import '../models/response_api.dart';
import '../models/usuario.dart';

class BovedaProvider extends GetConnect{


  String url = Environment.API_URL+"api/boveda";
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});



  Future<Boveda?> getAll(String idpeaje) async {
    Response response = await post(
      '$url/getall',
      {
        'id_peaje': idpeaje
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes acceso a esta información');
      return null;
    }

    if (response.statusCode == 200) {
      // Si la respuesta es un único objeto JSON
      if (response.body is Map<String, dynamic>) {
        return Boveda.fromJson(response.body);
      }
      // Si la respuesta es una lista, toma el primer objeto
      else if (response.body is List && response.body.isNotEmpty) {
        return Boveda.fromJson(response.body.first);
      }
    }

    return null;
  }

  Future<Boveda?> getSecreBoveda(String idpeaje) async {
    Response response = await post(
      '$url/getSecreBoveda',
      {
        'id_peaje': idpeaje
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes acceso a esta información');
      return null;
    }

    if (response.statusCode == 200) {
      // Si la respuesta es un único objeto JSON
      if (response.body is Map<String, dynamic>) {
        return Boveda.fromJson(response.body);
      }
      // Si la respuesta es una lista, toma el primer objeto
      else if (response.body is List && response.body.isNotEmpty) {
        return Boveda.fromJson(response.body.first);
      }
    }

    Get.snackbar(
        'Modo Offline',
        'No se ha podido conectar con el servidor',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        isDismissible: true,
        duration: const Duration(seconds: 60)
    );
    return null;
  }



  Future<ResponseApi> updateBoveda(Boveda boveda) async{

    Response response = await post(
        '$url/modificarBoveda',
        boveda.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );

    if(response.body==null){
      Get.snackbar(
          'Modo Offline',
          'No se ha podido conectar con el servidor',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          isDismissible: true,
          duration: const Duration(seconds: 60)
      );
      return ResponseApi();
    }

    if(response.statusCode==401){
      Get.snackbar('Error', 'No se esta autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }


  Future<ResponseApi> depositoBoveda(String idpeaje) async{

    Response response = await post(
        '$url/depositoBoveda',
        {
          'id_peaje': idpeaje
        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );

    if(response.body==null){
      Get.snackbar(
          'Modo Offline',
          'No se ha podido conectar con el servidor',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          isDismissible: true,
          duration: const Duration(seconds: 60)
      );
      return ResponseApi();
    }

    if(response.statusCode==401){
      Get.snackbar('Error', 'No se esta autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }


}