import 'package:asistencia_vial_app/src/pages/admin/profile/update/admin_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUpdate extends StatelessWidget {

  AdminUpdateController adminUpdateController = Get.put(AdminUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _buttonBack(),

          SingleChildScrollView( //scrolear para registrarse
            child: Column(
              children: [
                _imageCover(context),
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget _backgroundCover(BuildContext context){

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*1,
      color: Color(0xFF0077B6),
    );
  }

  Widget _imageCover(context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => adminUpdateController.showAlertDialog(context),
          child: GetBuilder<AdminUpdateController>(
            builder: (value) => CircleAvatar(
              backgroundImage: adminUpdateController.imageFile != null
                  ? FileImage(adminUpdateController.imageFile!)
                  : adminUpdateController.usuario.imagen != null
                  ? NetworkImage(adminUpdateController.usuario.imagen!)
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
            _textoUpdate(),
            _textFieldNombre(),
            _textFieldApellido(),
            _textFieldTelefono(),
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
            backgroundColor: Color(0xFF0077B6),
            padding: EdgeInsets.symmetric(vertical: 15),
            elevation: 10, // Controla la intensidad de la sombra
            shadowColor: Colors.black, // Color de la sombra
          ),

          onPressed: ()=> {},
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
            prefixIcon: Icon(Icons.supervised_user_circle, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.supervised_user_circle_outlined, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.call, color: Color(0xFF0077B6))
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
            icon: Icon(Icons.arrow_back_ios), color: Colors.white),
      ),
    );
  }
}
