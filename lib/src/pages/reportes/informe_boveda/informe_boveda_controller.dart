import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class InformeBovedaController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  List<Boveda>? bovedas;
  List<Movimiento>? movimientos;

  InformeBovedaController(List<Boveda> bovedas,List<Movimiento> movimientos) {
    this.bovedas=bovedas;
    this.movimientos=movimientos;
  }
}