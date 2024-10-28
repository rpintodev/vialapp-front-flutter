import 'package:asistencia_vial_app/src/pages/supervisor/asignacion/asignacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsignacionPage extends StatelessWidget {
  AsignacionController asignacionController=Get.put(AsignacionController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077B6)),
            onPressed: ()=>asignacionController.signOut(),
            child: Text('Cerrar Sesión - ASIGNACION',
              style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
