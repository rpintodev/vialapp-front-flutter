import 'dart:io';

import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../models/response_api.dart';
import '../../../../models/usuario.dart';

class AdminUpdateController extends GetxController{

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  UsuarioProvider usuarioProvider=UsuarioProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;


  AdminUpdateController(){

    nombreController.text= usuario.nombre ?? '';
    apellidoController.text= usuario.apellido ?? '';
    telefonoController.text= usuario.telefono ?? '';
  }

  void actualizar(BuildContext context) async{
    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text;



    if(isValidForm( nombre, apellido, telefono)){

      ProgressDialog progressDialog=ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando datos..');

      Usuario myUser=Usuario(
        id: usuario.id,
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,


      );

      /*
      Stream stream = await usuarioProvider.createWithImage(myUser, imageFile!);

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

       */



    }
  }


  bool isValidForm(String nombre, String apellido, String telefono){


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

    //QUITAR ESTA VALIDACION
    if(imageFile == null){
      Get.snackbar('Error', 'Debe seleccionar una imagen');
      return false;
    }

    return true;

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



}