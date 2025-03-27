import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:asistencia_vial_app/src/models/response_api.dart';
import 'package:asistencia_vial_app/src/models/rol.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/provider/rol_provider.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../models/peaje.dart';
import '../../provider/peaje_provider.dart';

class RegisterController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  Uint8List? signature;


  TextEditingController usuarioController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();


  UsuarioProvider usuarioProvider=UsuarioProvider();
  RolProvider rolProvider=RolProvider();
  PeajeProvider peajeProvider=PeajeProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  //TRAER LA LISTA DE ROLES Y PONERLOS EN EL DROPDOWN
  List<Rol> roles=<Rol>[].obs;

  var idRol=''.obs;

  void getRoles()async{
    var result=await rolProvider.getAll();
    roles.clear();
    roles.addAll(result);


  }


  //TRAER LA LISTA DE GRUPOS Y PONERLOS EN EL DROPDOWN
  List<String> grupos=<String>[].obs;
  var grupoSeleccionado=''.obs;
  void getGrupos()async{
    var result =await usuarioProvider.getGrupos();
    grupos.clear();
    grupos.addAll(result);

  }



  //TRAER LA LISTA DE ROLES Y PONERLOS EN EL DROPDOWN
  List<Peaje> peajes=<Peaje>[].obs;
  var idPeaje=''.obs;

  void getPeajes()async{
    var result=await peajeProvider.getAll();
    peajes.clear();
    peajes.addAll(result);

  }


  //CARGA DE INFORAMCION AL CONSTRUCTOR
  RegisterController(){
    getRoles();
    getGrupos();
    getPeajes();
    update();
  }




  void register(BuildContext context) async{

    String usuario = usuarioController.text;
    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text;
    String password = passwordController.text;
    String confpassword = conPasswordController.text;



    print('Usuario: $usuario');
    print('Constraseña: $password');
    print('IdRol: $idRol');
    print('IdPeaje: $idPeaje');

    if(usuarioSession.roles?.first.id  == '1'){
      grupoSeleccionado.value='1';
    }else{
      idRol.value = '3';
      idPeaje.value=usuarioSession.idPeaje??'';
    }



    if(isValidForm(usuario, nombre, apellido, telefono, password, confpassword)){

      ProgressDialog progressDialog=ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Registrando datos..');




      Usuario usuarios=Usuario(



          usuario: usuario,
          nombre: nombre,
          apellido: apellido,
          telefono: telefono,
          password: password,
          //CAMBIE EL TIPO DE DATO Y QUITE LOS PARSE

          grupo: grupoSeleccionado.value,
          idRol: idRol.value,
          idPeaje: idPeaje.value,


      );


          if(imageFile==null && signature == null) {
            Response response = await usuarioProvider.create(usuarios);
            print('Response Api Data: ${response.body}');
            progressDialog.close();
            if (response.statusCode == 201) {
              Get.snackbar(
                  'Registro Existosa', 'El usuario ha sido registrado');
              Get.offNamedUntil(
                  '/home', (route) => false, arguments: {'index': 3});
            }
          }else if(imageFile != null && signature == null){
            Stream stream = await usuarioProvider.createWithImage(usuarios, imageFile!);
            progressDialog.close();

              stream.listen((res){
                ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

                  if(responseApi.success==true){
                    Get.snackbar('Registro Existoso', 'El usuario ha sido registrado');
                    Get.offNamedUntil(
                        '/home', (route) => false, arguments: {'index': 3});
                  }
              });

          }else if (imageFile == null && signature != null) {

            File signatureFile = await convertUint8ListToFile(signature!);
            Stream stream = await usuarioProvider.createWithSignature(usuarios, signatureFile);
            progressDialog.close();

            stream.listen((res){
              ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

              if(responseApi.success==true){
                Get.snackbar('Registro Existoso', 'El usuario ha sido registrado');
                Get.offNamedUntil(
                    '/home', (route) => false, arguments: {'index': 3});
              }
            });


          } else {

            File signatureFile = await convertUint8ListToFile(signature!);
            Stream stream = await usuarioProvider.createWithSignatureAndImage(usuarios, signatureFile,imageFile!);
            progressDialog.close();

            stream.listen((res){
              ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

              if(responseApi.success==true){
                Get.snackbar('Registro Existoso', 'El usuario ha sido registrado');
                Get.offNamedUntil(
                    '/home', (route) => false, arguments: {'index': 3});
              }
            });
          }
    }
  }

  bool isValidForm(String usuario, String nombre, String apellido, String telefono, String password, String confpassword){

    if(idRol.isEmpty){
      Get.snackbar('Error', 'Debe seleccionar un rol');
      return false;
    }

    if(idPeaje.isEmpty){
      Get.snackbar('Error', 'Debe seleccionar un peaje');
      return false;
    }

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


    if(idRol.value==''){
      Get.snackbar('Error', 'Debe seleccionar un rol');
      return false;
    }

    if(idPeaje.value==''){
      Get.snackbar('Error', 'Debe seleccionar un peaje');
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

  void saveSignature(Uint8List newSignature) {
    signature = newSignature;
    update(); // Actualiza la interfaz si es necesario
  }

  Future<File> convertUint8ListToFile(Uint8List signature) async {
    final tempDir = await getTemporaryDirectory(); // Obtén un directorio temporal
    final tempFile = File('${tempDir.path}/signature.png'); // Crea un archivo temporal con extensión .png
    await tempFile.writeAsBytes(signature); // Escribe el contenido del Uint8List en el archivo
    return tempFile; // Devuelve el archivo
  }


}

