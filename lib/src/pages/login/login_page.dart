import 'package:asistencia_vial_app/src/pages/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold( //posicionar uno encima de otro
      body: Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),
          Column( //posicionar elementos uno sobre otro
            children: [
              _imageCover(),
              _textAppName()
            ],
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

  Widget _textAppName(){
    return Text('ASISTENCIA VIAL',
    style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white
    ),
    );
  }

  Widget _imageCover(){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 15),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/login.png',
          width: 140,
          height: 140,
        ),
      ),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height *1,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.33),
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
            _textFieldPassword(),
            _bottomLogin(),
            _textoRegistro()
          ],

        ),
      ),
    );
  }

  Widget _bottomLogin(){
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

          onPressed: () => loginController.login(),
          child: Text('Iniciar Sesión',
            style: TextStyle(
              color: Colors.white
            ),
          )),
    );
  }

  Widget _textFieldUsuario(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 10),

      child: TextField(
        controller: loginController.usuarioController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Usuario',
              prefixIcon: Icon(Icons.account_circle, color: Color(0xFF0077B6))
        ),
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),

      child: TextField(
        controller: loginController.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock, color: Color(0xFF0077B6))
        ),
      ),
    );
  }

  Widget _textoLogin(){
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 50),
      child: Text(

        'INGRESA ESTA INFORMACIÓN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
      ),
    );
  }

  Widget _textoRegistro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
        onTap: () => loginController.gotoRegisterPage(),

        child: Text(
          'Registro de Usuarios',
          style: TextStyle(
            color: Color(0xFF0077B6),
            fontSize: 15,
          ),
        ),
        ),
      ],

    );
  }


}
