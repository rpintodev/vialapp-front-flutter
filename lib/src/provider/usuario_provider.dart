import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:get/get.dart';

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