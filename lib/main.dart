import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/pages/admin/tracker/tracker_page.dart';
import 'package:asistencia_vial_app/src/pages/login/login_page.dart';
import 'package:asistencia_vial_app/src/pages/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Usuario userSession=Usuario.fromJson(GetStorage().read('usuario')??{});

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
      initialRoute: userSession.id!=null ? '/admin/tracker' : '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/admin/tracker', page: () => TrackerPage()),

      ],
      theme: ThemeData(
        primaryColor: Color(0xFF0077B6),
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary:  Colors.black,
            onPrimary:  Colors.white,
            secondary: Color(0xFF0077B6),
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
