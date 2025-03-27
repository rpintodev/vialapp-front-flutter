import 'package:asistencia_vial_app/src/pages/admin/Usuarios/usuarios_admin.dart';
import 'package:asistencia_vial_app/src/pages/admin/estadisticas/estadisticas_page.dart';
import 'package:asistencia_vial_app/src/pages/Home/home_controller.dart';
import 'package:asistencia_vial_app/src/pages/boveda/boveda_page.dart';
import 'package:asistencia_vial_app/src/pages/secretaria/transacciones/transacciones_secre.dart';
import 'package:asistencia_vial_app/src/pages/secretaria/venta_tag/venta_tag.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/usuarios/usuarios_sup.dart';
import 'package:asistencia_vial_app/src/pages/transacciones/transacciones.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/custom_animated_bottom_bar.dart';
import '../profile/info/admin_profile.dart';
import '../supervisor/asignacion/asignacion.dart';


class HomePage extends StatelessWidget {

  HomeSupController homeSupController = Get.put(HomeSupController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
          index: homeSupController.indexTab.value,
          children: _getPages(), // Carga las páginas según el idRol
        )));
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Color(0xFF368983),
      showElevation: true,
      itemCornerRadius: 50,
      curve: Curves.easeIn,
      selectedIndex: homeSupController.indexTab.value,
      onItemSelected: (index) => homeSupController.chanceTab(index),
      items: _getBottomBarItems(), // Filtra los ítems del BottomNavigationBar
    ));
  }

  // Obtiene las páginas visibles según el idRol
  List<Widget> _getPages() {
    if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 1){ // Rol de administrador
      return [
        BovedaPage(),
        Transacciones(),
        EstadisticasPage(),
        UsuariosAdmin(),
      ];
    } else if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 2)  { // Rol de supervisor
      return [
        BovedaPage(),
        Transacciones(),
        AsignacionPage(),
        UsuariosSup(),
      ];
    } else if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 4)  { // Rol de supervisor
      return [
        BovedaPage(),
        TransaccionesSecre(),
        VentaTag(),
      ];
    } else if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 5)  { // Rol de supervisor
      return [
        BovedaPage(),
        Transacciones(),

      ];
    } else {
      return [AdminProfile()]; // Otros roles con menos acceso
    }
  }

  // Filtra los ítems del BottomNavigationBar según el idRol
  List<BottomNavyBarItem> _getBottomBarItems() {
    List<BottomNavyBarItem> items = [];
    if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 1){ // Rol de administrador
      items = [
        BottomNavyBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text('Bóveda'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.sync_alt_outlined),
          title: Text('Transacciones'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.stacked_bar_chart),
          title: Text('Estadisticas'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.supervised_user_circle_rounded),
          title: Text('Usuarios'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

      ];
    } else if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 2) { // Rol de supervisor
      items = [
        BottomNavyBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text('Bóveda'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.sync_alt_outlined),
          title: Text('Transacciones'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.engineering),
          title: Text('Personal'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.supervised_user_circle_rounded),
          title: Text('Usuarios'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

      ];
    }else if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 4) { // Rol de supervisor
      items = [
        BottomNavyBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text('Bóveda'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.sync_alt_outlined),
          title: Text('Transacciones'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.add_card_sharp),
          title: Text('Venta'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),


      ];
    }else if (homeSupController.usuario.roles?.first.id != null &&
        int.tryParse(homeSupController.usuario.roles!.first.id!)== 5) { // Rol de supervisor
      items = [
        BottomNavyBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text('Bóveda'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.sync_alt_outlined),
          title: Text('Transacciones'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),



      ];
    }
    return items;
  }
}

