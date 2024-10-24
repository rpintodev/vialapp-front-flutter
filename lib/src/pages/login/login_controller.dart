import 'package:asistencia_vial_app/src/models/response_api.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController{

  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsuarioProvider usuarioProvider = UsuarioProvider();

  void gotoRegisterPage(){
    Get.toNamed('/register');
  }
  void gotoTrackerPage(){
    Get.offNamedUntil('/admin/tracker',(route)=>false);
  }

  void login() async{
    String usuario = usuarioController.text.trim();
    String password = passwordController.text;

    print('Usuario: $usuario');
    print('Constraseña: $password');

    if(isValidForm(usuario, password)){

      ResponseApi responseApi=await usuarioProvider.login(usuario, password);
      print('Response API ${responseApi.toJson()}');

      if(responseApi.success==true){

        GetStorage().write('usuario', responseApi.data);//ALMACENANDO LOS DATOS DEL USUARIO EN SESION
        gotoTrackerPage();
        Get.snackbar('Bienvenido', responseApi.message??'');

      }else{
        Get.snackbar('Error', responseApi.message??'');

      }

    }

  }

  bool isValidForm(String usuario, String password){

    if(usuario.isEmpty){
      Get.snackbar('Error', 'Debe ingresar el usuario');
      return false;
    }
    if(password.isEmpty){
      Get.snackbar('Error', 'Debe ingresar la contraseña');
      return false;
    }

    return true;

  }


}