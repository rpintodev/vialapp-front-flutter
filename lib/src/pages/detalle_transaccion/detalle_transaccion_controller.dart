import 'package:asistencia_vial_app/src/pages/editar_transaccion/editar_transaccion.dart';
import 'package:asistencia_vial_app/src/pages/reportes/reporte_canje/reporte_canje.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/movimiento.dart';
import '../../models/usuario.dart';
import '../reportes/liquidacion_cajero/reporte_liquidacion.dart';

class DetalleTransaccionController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  List<Movimiento>? movimientos;
  MovimientoProvider movimientoProvider=MovimientoProvider();
  int? bandera;


  DetalleTransaccionController(List<Movimiento> movimientos,int bandera) {
    this.movimientos=movimientos;
    this.bandera=bandera;
  }


  void goToEditTransaccion(Movimiento movimiento) {
    Get.off(
          () => EditarTransaccionPage(movimiento: movimiento), // Página a la que navegas
    );

  }


  void goToReportes(String idturno) async{
    List<Movimiento>? movimientos;

    var result = await movimientoProvider.getMovimientoByTurno(idturno); //cambiar getApertura
    movimientos = result;
    Get.to(
          () => ReporteLiquidacion(usuario: usuarioSession,movimientos: movimientos), // Página a la que navegas
      arguments: usuarioSession, // Envía el objeto Usuario como argumento
    );

  }

  void goToReporteCaneje(String idturno) async{
    List<Movimiento>? movimientos;

    var result = await movimientoProvider.getMovimientoByTurno(idturno); //cambiar getApertura
    movimientos = result;
    Get.to(
          () => ReporteCanje(usuario: usuarioSession,movimientos: movimientos), // Página a la que navegas
      arguments: usuarioSession, // Envía el objeto Usuario como argumento
    );

  }




}