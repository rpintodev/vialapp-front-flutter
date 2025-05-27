import 'package:asistencia_vial_app/src/pages/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:signature/signature.dart';

import '../../models/peaje.dart';
import '../../models/rol.dart';
import '../../provider/rol_provider.dart';

class RegisterPage extends StatelessWidget {

  RegisterController registerController=Get.put(RegisterController());
  RolProvider rolProvider=RolProvider();
  final SignatureController signatureController = SignatureController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Obx(()=>Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),

          SingleChildScrollView( //scrolear para registrarse
            child: Column(
              children: [

                _imageCover(context),

              ],
            ),
          ),
          _buttonBack(),

        ],
    )),
    );
  }



  Widget _backgroundCover(BuildContext context){

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*1,
      color: Color(0xFF368983),
    );
  }

  Widget _imageCover(context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
    child: GestureDetector(
    onTap: () => registerController.showAlertDialog(context),
        child: GetBuilder<RegisterController>(
          builder: (value) => CircleAvatar(
            backgroundImage: registerController.imageFile != null
                ? FileImage(registerController.imageFile!)
                : AssetImage('assets/img/editar.png') ,
            radius: 60,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      ),
    );
  }


  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height *1,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.27),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[ //sombras
          BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 0.75)
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // Radio superior izquierdo
          topRight: Radius.circular(20), // Radio superior derecho
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textoLogin(),
            _textFieldUsuario(),
            _textFieldNombre(),
            _textFieldApellido(),
            _textFieldTelefono(),
            _textFieldPassword(),
            _textFieldConfPassword(),
            if(registerController.usuarioSession.roles?.first.id  == '1')...[
            _dropDownRoles(registerController.roles),
            _dropdownPeaje(registerController.peajes),
            ]else...[
              _dropdownGrupo(registerController.grupos),


            ],
            _signatureBox(context),
            _bottomLogin(context),
          ],

        ),
      ),
    );
  }


  List<DropdownMenuItem<String>>_dropDowItemsRoles(List<Rol> roles){
    List<DropdownMenuItem<String>> list=[];
    roles.forEach((rol){
      list.add(DropdownMenuItem(
        child: Text(rol.nombre??''),
        value: rol.id,
      ));
    });
    return list;
  }

  Widget _dropDownRoles(List<Rol> roles){
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 65, vertical: 5),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF368983),
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text(
            'Seleecione el rol',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16
            ),
          ),
          items: _dropDowItemsRoles(roles),
          value: registerController.idRol.value==''?null:registerController.idRol.value,
          onChanged: (option){
            registerController.idRol.value=option.toString();
          },

        )
    );
  }

  List<DropdownMenuItem<String>>_dropDownItemsPeaje(List<Peaje> peajes){
    List<DropdownMenuItem<String>> list=[];
    peajes.forEach((peaje){
      list.add(DropdownMenuItem(
        child: Text(peaje.nombre??''),
        value: peaje.id,
      ));
    });
    return list;
  }


  Widget _dropdownPeaje(List<Peaje> peajes){
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 65, vertical: 5),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF368983),
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text(
            'Seleecione el peaje',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16
            ),
          ),
          items: _dropDownItemsPeaje(peajes),
          value: registerController.idPeaje.value==''?null:registerController.idPeaje.value,
          onChanged: (option){
            registerController.idPeaje.value=option.toString();
          },

        )
    );
  }



  Widget _bottomLogin(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),

      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF368983),
            padding: EdgeInsets.symmetric(vertical: 15),
            elevation: 10, // Controla la intensidad de la sombra
            shadowColor: Colors.black, // Color de la sombra
          ),

          onPressed: ()=> registerController.register(context),
          child: Text('Registrar',
            style: TextStyle(
                color: Colors.white
            ),
          )),
    );
  }

  Widget _textFieldUsuario(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),

      child: TextField(
        controller: registerController.usuarioController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Usuario',
            prefixIcon: Icon(Icons.account_circle, color: Color(0xFF368983))
        ),
      ),
    );
  }

  Widget _textFieldNombre(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),

      child: TextField(
        controller: registerController.nombreController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.supervised_user_circle, color: Color(0xFF368983))
        ),
      ),
    );
  }

  Widget _textFieldApellido(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),
      child: TextField(
        controller: registerController.apellidoController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellido',
            prefixIcon: Icon(Icons.supervised_user_circle_outlined, color: Color(0xFF368983))
        ),
      ),
    );
  }

  Widget _textFieldTelefono(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),

      child: TextField(
        controller: registerController.telefonoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            prefixIcon: Icon(Icons.call, color: Color(0xFF368983))
        ),
      ),
    );
  }


  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),

      child: TextField(
        controller: registerController.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock, color: Color(0xFF368983))
        ),
      ),
    );
  }

  Widget _textFieldConfPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),

      child: TextField(
        controller: registerController.conPasswordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar Contraseña',
            prefixIcon: Icon(Icons.lock, color: Color(0xFF368983))
        ),
      ),
    );
  }

  Widget _textoLogin(){
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 15),
      child: Text(

        'REGISTRO DE USUARIOS',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,

        ),
      ),
    );
  }

  Widget _buttonBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios), color: Colors.white),
      ),
    );
  }

  List<DropdownMenuItem<String>>_dropDowItemsGrupos(List<String> grupos){
    List<DropdownMenuItem<String>> list=[];
    grupos.forEach((grupo){
      list.add(DropdownMenuItem(
        child: Text('Grupo: $grupo'??''),
        value: grupo,
      ));
    });
    return list;
  }


  Widget _dropdownGrupo(List<String> grupos){
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 65, vertical: 5),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF368983),
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text(
            'Selecione el grupo',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16
            ),
          ),
          items: _dropDowItemsGrupos(grupos),
          value: registerController.grupoSeleccionado.value==''?null:registerController.grupoSeleccionado.value,
          onChanged: (option){
            registerController.grupoSeleccionado.value=option.toString();
          },

        )
    );
  }


  Widget _signatureBox(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSignaturePad(context),
      child: GetBuilder<RegisterController>(
        builder: (controller) => Container(
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              controller.signature == null
                  ? Column(
                children: [
                  Icon(Icons.edit, size: 30, color: Color(0xFF368983)),
                  SizedBox(height: 5),
                  Text(
                    'Capturar Firma',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
                  : Image.memory(
                controller.signature!,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _openSignaturePad(BuildContext context) {
    final signatureController = SignatureController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Captura tu Firma"),
          content: SizedBox(
         width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Signature(
                controller: signatureController,
                height: 150,
                backgroundColor: Colors.grey[200]!,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => signatureController.clear(),
                    child: Text("Borrar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (signatureController.isNotEmpty) {
                        final signature = await signatureController.toPngBytes();
                        if (signature != null) {
                          registerController.saveSignature(signature);
                        }
                        Navigator.of(context).pop(); // Cierra el diálogo
                      } else {
                        Get.snackbar(
                          "Error",
                          "La firma está vacía.",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Guardar"),
                  ),
                ],
              ),
            ],
          ),
          ),
        );
      },
    );
  }




}
