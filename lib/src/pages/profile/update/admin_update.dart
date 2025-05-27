import 'package:asistencia_vial_app/src/pages/profile/update/admin_update_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../models/peaje.dart';
import '../../../models/rol.dart';
import '../../../models/usuario.dart';

class AdminUpdate extends StatelessWidget {

  Usuario? usuario;

  late AdminUpdateController adminUpdateController;
  final SignatureController signatureController = SignatureController();

  AdminUpdate({this.usuario}){
    adminUpdateController= Get.put(AdminUpdateController(usuario));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),

          SingleChildScrollView( //scrolear para registrarse
            child: Column(
              children: [
                _imageCover(context,usuario),
              ],
            ),

          ),

          _buttonBack(),

        ],
      ),
    ));
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
          value: adminUpdateController.grupoSeleccionado.value==''?null:adminUpdateController.grupoSeleccionado.value,
          onChanged: (option){
            adminUpdateController.grupoSeleccionado.value=option.toString();
          },

        )
    );
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
            value: adminUpdateController.idRol.value==''?null:adminUpdateController.idRol.value,
            onChanged: (option){
                adminUpdateController.idRol.value=option.toString();
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
          value: adminUpdateController.idPeaje.value==''?null:adminUpdateController.idPeaje.value,
          onChanged: (option){
            adminUpdateController.idPeaje.value=option.toString();
          },

        )
    );
  }



  Widget _backgroundCover(BuildContext context){

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*1,
      color: Color(0xFF368983),
    );
  }

  Widget _imageCover(BuildContext context, Usuario? usuario) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => adminUpdateController.showAlertDialog(context),
          child: GetBuilder<AdminUpdateController>(
            builder: (value) => CircleAvatar(
              backgroundImage: adminUpdateController.imageFile != null
                  ? FileImage(adminUpdateController.imageFile!) // Imagen seleccionada
                  : (usuario?.imagen != null && usuario!.imagen!.isNotEmpty) // Verifica si usuario.imagen no está vacía
                  ? NetworkImage(usuario.imagen!) // Imagen de usuario
                  : AssetImage('assets/img/no-image.png') as ImageProvider, // Imagen predeterminada
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
            _textoUpdate(),
            _textFieldNombre(),
            _textFieldApellido(),
            _textFieldTelefono(),
            if (adminUpdateController.usuarioSession.roles?.first.id  == '1') ...[
              _dropDownRoles(adminUpdateController.roles), // Dropdown de Roles
              _dropdownGrupo(adminUpdateController.grupos), // Dropdown de Grupos
              _dropdownPeaje(adminUpdateController.peajes), // Dropdown de Peajes
            ] else...[
              _dropdownGrupo(adminUpdateController.grupos), // Solo mostramos Grupos
            ],
            _signatureBox(context),
            _bottomUpdate(context),
          ],

        ),
      ),
    );
  }

  Widget _bottomUpdate(BuildContext context){
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

          onPressed: () => adminUpdateController.actualizar(context),
          child: Text('Actualizar',
            style: TextStyle(
                color: Colors.white
            ),
          )),
    );
  }



  Widget _textFieldNombre(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 5),

      child: TextField(
        controller: adminUpdateController.nombreController,
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
        controller: adminUpdateController.apellidoController,
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
        controller: adminUpdateController.telefonoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            prefixIcon: Icon(Icons.call, color: Color(0xFF368983))
        ),
      ),
    );
  }



  Widget _textoUpdate(){
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 50),
      child: Text(

        'ACTUALIZACION DE DATOS',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
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
            icon: Icon(Icons.arrow_back), color: Colors.white),
      ),
    );
  }


  Widget _signatureBox(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSignaturePad(context),
      child: GetBuilder<AdminUpdateController>(
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
                            adminUpdateController.saveSignature(signature);
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
