import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/response_api.dart';

class UsuarioProvider extends GetConnect{

  String url = Environment.API_URL+"api/usuarios";

  Future<Response> create(Usuario usuario) async{
    Response response = await post(
        '$url/create',
        usuario.toJson(),
        headers: {'Content-type': 'application/json'}

    );
    return response;
  }

  Future<Stream> createWithImage(Usuario usuario, File image)async{
    Uri uri = Uri.http(Environment.API_URL_OLD,'/api/usuarios/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
        'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(),
      filename: basename(image.path)
    ));
    request.fields['usuario']=json.encode(usuario);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  /*METODO GETX*/

  Future<ResponseApi> createWithImageGetX(Usuario usuario, File image) async{
    FormData form = FormData({

      'image':MultipartFile(image,filename: basename(image.path)),
      'usuario':json.encode(usuario)
    });
    Response response = await post('$url/createWithImage',form);

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }

    ResponseApi responseApi=ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> login(String usuario,String password) async{
    Response response = await post(
        '$url/login',
        {
          'Usuario': usuario,
          'Password': password

        },
        headers: {'Content-type': 'application/json'}

    );//ESPERA A QUE EL SERVIDOR RETORNE LA RESPUESTA

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }

    ResponseApi responseApi=ResponseApi.fromJson(response.body);
    return responseApi;
  }

}