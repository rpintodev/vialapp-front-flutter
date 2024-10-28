import 'package:asistencia_vial_app/src/pages/admin/profile/info/admin_profile.dart';
import 'package:asistencia_vial_app/src/pages/admin/tracker/tracker_controller.dart';
import 'package:asistencia_vial_app/src/pages/chofer/asistencias/asistencias.dart';
import 'package:asistencia_vial_app/src/pages/register/register_page.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/asignacion/asignacion.dart';
import 'package:asistencia_vial_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TrackerPage extends StatelessWidget {

  TrackerController trackerController = Get.put(TrackerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(()=>IndexedStack(
        index: trackerController.indexTab.value,
        children: [
          AsistenciasPage(),
          AsignacionPage(),
          AdminProfile()
        ],
      )
      )
    );
  }

  Widget _bottomBar(){
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Color(0xFF0077B6),
      showElevation: true,
      itemCornerRadius: 50,
      curve: Curves.easeIn,
      selectedIndex: trackerController.indexTab.value,
      onItemSelected: (index)=> trackerController.chanceTab(index),
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.gps_fixed),
            title: Text('Tracker'),
            activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.fire_truck),
            title: Text('Vechículos'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,

        ),
        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Usuarios'),
            activeColor: Colors.white,
          inactiveColor: Colors.black,

        ),
      ],
    )
    );
  }
}
