import 'package:asistencia_vial_app/src/pages/admin/profile/info/admin_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/rol.dart';

class AdminProfile extends StatelessWidget {

  AdminProfileController adminProfileController = Get.put(AdminProfileController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imageCover(context),
          _buttonSignOut(),

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
        child: CircleAvatar(
          backgroundImage: adminProfileController.usuario.imagen != null
              ? NetworkImage(adminProfileController.usuario.imagen!)
              : AssetImage('assets/img/editar.png') ,
          radius: 60,
          backgroundColor: Colors.white,
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
              blurRadius: 20,
              offset: Offset(0, -20),
            spreadRadius: -7,


          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // Radio superior izquierdo
          topRight: Radius.circular(20), // Radio superior derecho
        ),
      ),
      child: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _textName(),
            _textUsuario(),
            _textphone(),
            _textRol(),
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

          onPressed: () => adminProfileController.gotoUpdate(),
          child: Text('ACTUALIZAR DATOS',
            style: TextStyle(
                color: Colors.white
            ),
          )),
    );
  }




  Widget _textName(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          leading: Icon(Icons.perm_contact_cal_sharp),
          title: Text('${adminProfileController.usuario.nombre??''} ${adminProfileController.usuario.apellido??''}',
            style: TextStyle(color: Colors.black)),
          subtitle:  Text('Nombres'),

        )
    );
  }

  Widget _textRol(){
    Rol? rol = adminProfileController.usuario.roles?.isNotEmpty == true ? adminProfileController.usuario.roles!.first : null;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          leading: Icon(Icons.work),
          title: Text('${rol?.nombre ??''}',
              style: TextStyle(color: Colors.black)),
          subtitle:  Text('Rol'),

        )
    );
  }



  Widget _textUsuario(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
        leading: Icon(Icons.person_outlined),
        title: Text('${adminProfileController.usuario.usuario??''}', style: TextStyle(color: Colors.black),),
        subtitle:  Text('Usuario'),

      )
    );
  }

  Widget _textphone(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          leading: Icon(Icons.phone),
          title: Text('${adminProfileController.usuario.telefono??''}', style: TextStyle(color: Colors.black),),
          subtitle:  Text('Telefono'),

        )
    );
  }

  Widget _buttonSignOut(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () => adminProfileController.signOut(),
            icon: Icon(Icons.output_sharp), color: Colors.white),
      ),
    );
  }


}
