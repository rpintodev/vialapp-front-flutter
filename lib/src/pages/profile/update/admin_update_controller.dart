import 'dart:convert';
import 'dart:io';

import 'package:asistencia_vial_app/main.dart';
import 'package:asistencia_vial_app/src/models/rol.dart';
import 'package:asistencia_vial_app/src/pages/profile/info/admin_profile_controller.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../models/peaje.dart';
import '../../../models/response_api.dart';
import '../../../models/usuario.dart';
import '../../../provider/peaje_provider.dart';
import '../../../provider/rol_provider.dart';

class AdminUpdateController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  var grupoSeleccionado=''.obs;
  var idRol=''.obs;
  String idUsuario='';
  List<Rol> roles=<Rol>[].obs;
  List<String> grupos=<String>[].obs;


  UsuarioProvider usuarioProvider=UsuarioProvider();
  RolProvider rolProvider=RolProvider();
  PeajeProvider peajeProvider=PeajeProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  //TRAER LA LISTA DE ROLES Y PONERLOS EN EL DROPDOWN
  List<Peaje> peajes=<Peaje>[].obs;
  var idPeaje=''.obs;

  void getPeajes()async{
    var result=await peajeProvider.getAll();
    peajes.clear();
    peajes.addAll(result);

  }



  AdminUpdateController(Usuario? usuario){

    getGrupos();
    getRoles();
    getPeajes();


    if(usuario==null){
      idUsuario=usuarioSession.id??'';
      nombreController.text = usuarioSession.nombre ?? '';
      apellidoController.text = usuarioSession.apellido ?? '';
      telefonoController.text = usuarioSession.telefono ?? '';
      grupoSeleccionado.value = usuarioSession.grupo ?? '';
      idRol.value = usuarioSession.roles?.first.id ?? '';
      idPeaje.value = usuarioSession.idPeaje ?? '';


    }else{
      idUsuario=usuario.id??'';
      nombreController.text= usuario.nombre ?? '';
      apellidoController.text= usuario.apellido ?? '';
      telefonoController.text= usuario.telefono ?? '';
      grupoSeleccionado.value = usuario.grupo ?? '';
      idRol.value= usuario.idRol ?? '';
      idPeaje.value= usuario.idPeaje ?? '';

    }


  }

  void getRoles()async{
    var result =await rolProvider.getAll();
    roles.clear();
    roles.addAll(result);

  }

  void getGrupos()async{
    var result =await usuarioProvider.getGrupos();
    grupos.clear();
    grupos.addAll(result);

  }

  void actualizar(BuildContext context) async{

    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text;
    String idRolS = idRol.value;
    String grupo = grupoSeleccionado.value;
    String idPeajeS = idPeaje.value;




    if(isValidForm( nombre, apellido, telefono)){

      ProgressDialog progressDialog=ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando datos..');

      Usuario myUser=Usuario(

        id: idUsuario,
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        idRol: idRolS,
        grupo: grupo,
        idPeaje: idPeajeS,
        sessionToken: usuarioSession.sessionToken,

      );

      if(imageFile==null) {
        ResponseApi responseApi = await usuarioProvider.update(myUser);
        print('Response Api Data: ${responseApi.data}');
        progressDialog.close();

        if(responseApi.success ==true){
          Get.snackbar('Actualizacion Existosa', 'El usuario ha sido actualizado');
          Get.offNamedUntil('/home', (route)=>false, arguments: {'index': 3});

        }
      }else{
        Stream stream = await usuarioProvider.updateWithImage(myUser, imageFile!);

         progressDialog.close();
          stream.listen((res){
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          print('Response Api Data: ${responseApi.data}');
          Get.snackbar('Actualizacion Existoso', 'El usuario ha sido actualizado');
          Get.offNamedUntil('/home', (route)=>false);

          if(responseApi.success==true){

            Get.snackbar('Actualizacion Existoso', 'El usuario ha sido actualizado');
            Get.offNamedUntil('/home', (route)=>false);

            Get.back();


          }else{
            Get.snackbar('ERROR ', responseApi.message??'');

          }

        });

      }





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
        backgroundColor: Color(0xFF368983),
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
        backgroundColor: Color(0xFF368983),
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