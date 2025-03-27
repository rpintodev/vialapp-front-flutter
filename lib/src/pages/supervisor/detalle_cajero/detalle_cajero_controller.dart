import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class DetalleCajeroController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  late List<Movimiento>? movimientos;

  DetalleCajeroController(List<Movimiento> movimientos) {
    this.movimientos=movimientos;
  }

}