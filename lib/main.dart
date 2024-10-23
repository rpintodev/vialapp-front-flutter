import 'package:asistencia_vial_app/src/pages/login/login_page.dart';
import 'package:asistencia_vial_app/src/pages/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
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
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
      ],
      theme: ThemeData(
        primaryColor: Color(0xFF0077B6),
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary:  Color(0xFF0077B6),
            onPrimary:  Color(0xFF0077B6),
            secondary: Color(0xFF0077B6),
            onSecondary: Colors.grey,
            error: Colors.white,
            onError: Colors.grey,
            surface: Colors.grey,
            onSurface: Colors.grey,
        ),
      ),
      navigatorKey: Get.key,
    );
  }
}
