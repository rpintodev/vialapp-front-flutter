import 'package:asistencia_vial_app/src/pages/chofer/asistencias/asistencias_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsistenciasPage extends StatelessWidget {

  AsistenciasController asistenciasController = Get.put(AsistenciasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077B6)),
            onPressed: ()=>asistenciasController.signOut(),
            child: Text('Cerrar Sesión- ASISTENCIAS',
              style: TextStyle(color: Colors.white),)),

      ),
    );
  }
}
