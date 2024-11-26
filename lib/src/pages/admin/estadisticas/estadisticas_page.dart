import 'package:asistencia_vial_app/src/pages/admin/Usuarios/usuarios_admin_controller.dart';
import 'package:asistencia_vial_app/src/pages/admin/estadisticas/estadisticas_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstadisticasPage extends StatelessWidget {

  EstadisticasController estadisticasController = Get.put(EstadisticasController());

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
                onPressed: ()=>estadisticasController.gotoRegisterPage(),
                child: Text('Cerrar Sesión- ESTADISCTICAS',
                  style: TextStyle(color: Colors.white),)),
          ),
          SizedBox(height: 20), // Espaciado entre los botones


        ],
      ),
    );
  }
}