import 'package:asistencia_vial_app/src/pages/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class RegisterPage extends StatelessWidget {

  RegisterController registerController=Get.put(RegisterController());

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
            _bottomLogin(context),
          ],

        ),
      ),
    );
  }

  Widget _bottomLogin(BuildContext context){
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
            prefixIcon: Icon(Icons.account_circle, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.supervised_user_circle, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.supervised_user_circle_outlined, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.call, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.lock, color: Color(0xFF0077B6))
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
            prefixIcon: Icon(Icons.lock, color: Color(0xFF0077B6))
        ),
      ),
    );
  }

  Widget _textoLogin(){
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 50),
      child: Text(

        'REGISTRO DE USUARIOS',
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
