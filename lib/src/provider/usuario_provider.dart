import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/response_api.dart';

class UsuarioProvider extends GetConnect{

  String url = Environment.API_URL+"api/usuarios";
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});


  Future<ResponseApi> update(Usuario usuario) async{

    Response response = await post(
        '$url/updateWithOutImage',
        usuario.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }

    if(response.statusCode==401){
      Get.snackbar('Error', 'No se esta autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

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

  Future<Stream> updateWithImage(Usuario usuario, File image)async{
    Uri uri = Uri.http(Environment.API_URL_OLD,'/api/usuarios/update');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization']=usuario.sessionToken??'';
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


  /*METODO GETX CON IMAGEN*/

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


  Future<List<Usuario>> getAll() async {

    Response response = await get(
        '$url/getall',
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Usuario> usuarios= Usuario.fromJsonList(response.body);
    return usuarios;

  }

  Future<List<String>> getGrupos() async {

    Response response = await get(
        '$url/getGrupos',
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<String> grupos= Usuario.extractDistinctGroups(response.body);
    return grupos;

  }


  Future<List<Usuario>> findByRol(String idRol) async {

    Response response = await get(
        '$url/findByRol/$idRol',
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Usuario> usuarios= Usuario.fromJsonList(response.body);
    return usuarios;

  }

  Future<List<Usuario>> findByGrupo(String idGrupo) async {

    Response response = await get(
        '$url/findByGrupo/$idGrupo',
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Usuario> usuarios= Usuario.fromJsonList(response.body);
    return usuarios;

  }

}