import 'package:asistencia_vial_app/src/models/response_api.dart';
import 'package:asistencia_vial_app/src/pages/editar_transaccion/editar_transaccion.dart';
import 'package:asistencia_vial_app/src/pages/reportes/reporte_canje/reporte_canje.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/movimiento.dart';
import '../../models/usuario.dart';
import '../../provider/usuario_provider.dart';
import '../reportes/liquidacion_cajero/reporte_liquidacion.dart';
import '../supervisor/faltante/faltante.dart';

class DetalleTransaccionController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  List<Movimiento>? movimientos;
  UsuarioProvider usuarioProvider=UsuarioProvider();

  MovimientoProvider movimientoProvider=MovimientoProvider();
  int? bandera;


  DetalleTransaccionController(List<Movimiento> movimientos,int bandera) {
    this.movimientos=movimientos;
    this.bandera=bandera;
    print('Bandera $bandera');

  }


  void goToEditTransaccion(Movimiento movimiento) {
    Get.off(
          () => EditarTransaccionPage(movimiento: movimiento), // Página a la que navegas
    );

  }

  void goToFaltantes(String idturno) async{
    List<Usuario> usuarios = await usuarioProvider.findByTurno(idturno);
    List<Movimiento>? movimientos;
    Movimiento liquidacion;
    var result = await movimientoProvider.getMovimientoByTurno(idturno??''); //cambiar getApertura
    movimientos = result;
    liquidacion = movimientos.firstWhere((m)=> m.idTipoMovimiento =='4');
    if(usuarioSession.roles?.first.id=='6'&& liquidacion.estado=='0'){
      liquidacion.idSupervisor=usuarioSession.id;
      liquidacion.estado='1';
      ResponseApi response2 = await movimientoProvider.updateEstadoMovimiento(liquidacion);
    }
    Usuario usuario = usuarios.firstWhere((m)=> m.id=='${liquidacion.idCajero}');
    Get.to(
          () => FaltantesPage(movimientos: movimientos, bandera: bandera),
      arguments: usuario,// Página a la que navegas
    );


  }

  void goToReportes(String idturno) async{
    List<Movimiento>? movimientos;
    Movimiento liquidacion;

    var result = await movimientoProvider.getMovimientoByTurno(idturno); //cambiar getApertura
    movimientos = result;

    liquidacion = movimientos.firstWhere((m)=> m.idTipoMovimiento =='4');
    if(usuarioSession.roles?.first.id=='6'&& liquidacion.estado=='0'){
      liquidacion.idSupervisor=usuarioSession.id;
      liquidacion.estado='1';
      await movimientoProvider.updateEstadoMovimiento(liquidacion);
    }

    Get.to(
          () => ReporteLiquidacion(movimientos: movimientos), // Página a la que navegas
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