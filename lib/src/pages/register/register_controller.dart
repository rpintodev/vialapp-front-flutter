import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:asistencia_vial_app/src/models/response_api.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController extends GetxController{

  TextEditingController usuarioController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  UsuarioProvider usuarioProvider=UsuarioProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;


  void register(BuildContext context) async{
    String usuario = usuarioController.text;
    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text;
    String password = passwordController.text;
    String confpassword = conPasswordController.text;

    print('Usuario: $usuario');
    print('Constraseña: $password');



    if(isValidForm(usuario, nombre, apellido, telefono, password, confpassword)){

      ProgressDialog progressDialog=ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Registrando datos..');

      Usuario usuarios=Usuario(
          usuario: usuario,
          nombre: nombre,
          apellido: apellido,
          telefono: telefono,
          password: password,


      );

      Stream stream = await usuarioProvider.createWithImage(usuarios, imageFile!);

      progressDialog.close();
      stream.listen((res){
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if(responseApi.success==true){
          Get.snackbar('Registro Existoso', 'El usuario ha sido registrado');
          Get.offNamedUntil('/login',(route)=>false);
        }else{
          Get.snackbar('ERROR ', responseApi.message??'');

        }

      });



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

    //QUITAR ESTA VALIDACION
    if(imageFile == null){
      Get.snackbar('Error', 'Debe seleccionar una imagen');
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

  Future selectImage(ImageSource imageSource) async{
    XFile? image = await picker.pickImage(source: imageSource);
    if(image != null){
      imageFile = File(image.path);
      update();
    }
  }


  void showAlertDialog(BuildContext context) {
    // Personalización del botón de la galería
    Widget galleryButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0077B6),
        elevation: 10, // Controla la intensidad de la sombra
        shadowColor: Colors.black, // C
      ),
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);

      },
      child: Text('GALERIA',style: TextStyle(color: Colors.white)),
    );

    Widget cameraButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0077B6),
        elevation: 10, // Controla la intensidad de la sombra
        shadowColor: Colors.black, // C
      ),
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);

      },
      child: Text('CAMARA',style: TextStyle(color: Colors.white)),
    );

    // Creación del AlertDialog con fondo blanco y letras negras
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white, // Fondo blanco
      title: Text(
        'Seleccione una opción',
        style: TextStyle(color: Colors.black), // Letras negras
      ),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    // Mostrar el cuadro de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }


  void gotoLoginPage(){
    Get.toNamed('/');
  }

}

