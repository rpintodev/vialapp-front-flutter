import 'package:asistencia_vial_app/src/pages/admin/Usuarios/usuarios_admin_controller.dart';
import 'package:asistencia_vial_app/src/pages/admin/boveda/boveda_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BovedaAdminPage extends StatelessWidget {

  BovedaAdminController bovedaAdminController = Get.put(BovedaAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los botones

        children: [

          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF368983)),
                onPressed: ()=>bovedaAdminController.signOut(),
                child: Text('Cerrar Sesión- BOVEDA ADMIN',
                  style: TextStyle(color: Colors.white),)),
          ),
          SizedBox(height: 20), // Espaciado entre los botones



        ],
      ),
    );
  }
}