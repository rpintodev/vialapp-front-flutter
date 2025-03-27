import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class ReporteCanjeController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  Usuario? usuario;
  List<Movimiento>? movimientos;

  ReporteCanjeController(Usuario usuario,List<Movimiento> movimientos) {
    this.usuario=usuario;
    this.movimientos=movimientos;
  }
}