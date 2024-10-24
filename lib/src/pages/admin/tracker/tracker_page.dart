import 'package:asistencia_vial_app/src/pages/admin/tracker/tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackerPage extends StatelessWidget {

  TrackerController trackerController = Get.put(TrackerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0077B6)),
            onPressed: ()=>trackerController.signOut(),
            child: Text('Cerrar Sesión',
            style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
