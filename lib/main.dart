import 'package:asistencia_vial_app/src/models/rol.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/pages/admin/Usuarios/usuarios_admin.dart';
import 'package:asistencia_vial_app/src/pages/admin/estadisticas/estadisticas_page.dart';
import 'package:asistencia_vial_app/src/pages/detalle_transaccion/detalle_transaccion.dart';
import 'package:asistencia_vial_app/src/pages/profile/info/admin_profile.dart';
import 'package:asistencia_vial_app/src/pages/profile/update/admin_update.dart';
import 'package:asistencia_vial_app/src/pages/login/login_page.dart';
import 'package:asistencia_vial_app/src/pages/register/register_page.dart';
import 'package:asistencia_vial_app/src/pages/Home/home_page.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/apertura/apertura.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/asignacion/asignacion.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/canje/canje.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/detalle_cajero/detalle_cajero.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/liquidaciones/liquidaciones.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiro_apertura/retiro_apertura.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiro_fortius/retiro_fortius.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiros_parciales/retiro_parcial.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/usuarios/usuarios_sup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'src/pages/detalle/detalle_usuario.dart';
import 'src/pages/supervisor/canje_fortius/canje_fortius.dart';
import 'src/pages/transacciones/transacciones.dart';

Usuario userSession=Usuario.fromJson(GetStorage().read('usuario')??{});
Rol? rol = userSession.roles?.isNotEmpty == true ? userSession.roles!.first : null;


void main() async{

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Asistencias App',
      debugShowCheckedModeBanner: false,



      initialRoute: userSession.id!=null ? rol?.ruta : '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/detalle', page: () => DetalleUsuario()),
        GetPage(name: '/transacciones', page: () => Transacciones()),
        GetPage(name: '/detalletransaccion', page: () => DetalleTransaccion()),
        GetPage(name: '/admin/estadisticas', page: () => EstadisticasPage()),
        GetPage(name: '/admin/usuarios', page: () => UsuariosAdmin()),
        GetPage(name: '/supervisor/usuarios', page: () => UsuariosSup()),
        GetPage(name: '/profile/info', page: () => AdminProfile()),
        GetPage(name: '/profile/update', page: () => AdminUpdate()),
        GetPage(name: '/supervisor/asignacion', page: () => AsignacionPage()),
        GetPage(name: '/supervisor/canje', page: () => CanjePage()),
        GetPage(name: '/supervisor/detallecajero', page: () => DetalleCajero()),
        GetPage(name: '/supervisor/retiroparcial', page: () => RetiroParcialPage()),
        GetPage(name: '/supervisor/retiroapertura', page: () => RetiroAperturaPage()),
        GetPage(name: '/supervisor/liquidaciones', page: () => LiquidacionesPage()),
        GetPage(name: '/supervisor/apertura', page: () => AperturaPage()),
        GetPage(name: '/supervisor/retirofortius', page: () => RetiroFortiusPage()),
        GetPage(name: '/supervisor/canjefortius', page: () => CanjeFortiusPage()),





      ],
      theme: ThemeData(
        primaryColor: Color(0xFF368983),
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary:  Colors.black,
            onPrimary:  Colors.white,
            secondary: Color(0xFF368983),
            onSecondary: Colors.white,
            error: Colors.white,
            onError: Colors.grey,
            surface: Colors.white,
            onSurface: Colors.grey,

        ),
      ),
      navigatorKey: Get.key,
    );
  }
}
