import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../editar_transaccion/editar_transaccion.dart';

class DetalleCajeroController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  late List<Movimiento>? movimientos;

  DetalleCajeroController(List<Movimiento> movimientos) {
    this.movimientos=movimientos;
  }

  void goToEditTransaccion(Movimiento movimiento) {
    Get.off(
          () => EditarTransaccionPage(movimiento: movimiento), // Página a la que navegas
    );

  }

}