import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{

  TextEditingController usuarioController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  UsuarioProvider usuarioProvider=UsuarioProvider();

  void register() async{
    String usuario = usuarioController.text;
    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text;
    String password = passwordController.text;
    String confpassword = conPasswordController.text;

    print('Usuario: $usuario');
    print('Constraseña: $password');

    if(isValidForm(usuario, nombre, apellido, telefono, password, confpassword)){

      Usuario usuarios=Usuario(
          usuario: usuario,
          nombre: nombre,
          apellido: apellido,
          telefono: telefono,
          password: password,


      );

      Response response= await usuarioProvider.create(usuarios);

      print('RESPONSE : ${response.body}');
      clearField();
      Get.snackbar('Bienvenido', 'Registro exitoso');

    }
  }

  bool isValidForm(String usuario, String nombre, String apellido, String telefono, String password, String confpassword){

    if(usuario.isEmpty){
      Get.snackbar('Error', 'Debe ingresar el usuario');
      return false;
    }
    if(nombre.isEmpty){
      Get.snackbar('Error', 'Debe ingresar el nombre');
      return false;
    }
    if(apellido.isEmpty){
      Get.snackbar('Error', 'Debe ingresar el apellido');
      return false;
    }
    if(telefono.isEmpty){
      Get.snackbar('Error', 'Debe ingresar el telefono');
      return false;
    }

    if(password.isEmpty){
      Get.snackbar('Error', 'Debe ingresar la contraseña');
      return false;
    }

    if(confpassword.isEmpty){
      Get.snackbar('Error', 'Debe ingresar la contraseña');
      return false;
    }

    if(confpassword!=password){
      Get.snackbar('Error', 'La contraseña no coincide');
      return false;
    }

    return true;

  }

  void clearField() {
    usuarioController.clear();
    nombreController.clear();
    apellidoController.clear();
    telefonoController.clear();
    passwordController.clear();
    conPasswordController.clear();
  }

}

