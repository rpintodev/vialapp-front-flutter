import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class ReporteLiquidacionController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  List<Movimiento>? movimientos;

  ReporteLiquidacionController(List<Movimiento> movimientos) {
    this.movimientos=movimientos;
  }
}