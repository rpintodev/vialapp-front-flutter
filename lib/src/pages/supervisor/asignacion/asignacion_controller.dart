import 'package:asistencia_vial_app/src/models/estado.dart';
import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/reporte_liquidacion.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/apertura/apertura.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/canje/canje.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/detalle_cajero/detalle_cajero.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/faltante/faltante.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/liquidaciones/liquidaciones.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiro_apertura/retiro_apertura.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiros_parciales/retiro_parcial.dart';
import 'package:asistencia_vial_app/src/provider/estado_provider.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:asistencia_vial_app/src/provider/turno_provider.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../models/usuario.dart';
import '../../detalle_transaccion/detalle_transaccion.dart';

class AsignacionController extends GetxController{

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});
  EstadoProvider estadoProvider=EstadoProvider();
  MovimientoProvider movimientoProvider=MovimientoProvider();
  UsuarioProvider usuarioProvider=UsuarioProvider();
  TurnoProvider turnoProvider=TurnoProvider();
  List<Estado> estados= <Estado>[].obs;

  Movimiento movimiento=Movimiento();
  Movimiento faltante=Movimiento();

  AsignacionController(){

    getEstados();

  }



  void clearMovimiento() {
    movimiento = Movimiento();
    faltante= Movimiento();// Restablece a un objeto vacío
    update(); // Notifica a las vistas que el estado ha cambiado
  }




  void goToCanje(Usuario usuario) async{
    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientoByTurno(usuario.idTurno??''); //cambiar getApertura
    movimientos = result;

    Get.to(
          () => CanjePage(usuario: usuario, movimientos: movimientos), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void getApertura(String idTurno) async{
    clearMovimiento();
    var result = await movimientoProvider.getApertura(idTurno);
    movimiento = result!;
    update();
  }

  Future<Movimiento?> getMovimientoPorUsuario(String idTurno) async {
    return await movimientoProvider.getApertura(idTurno);
  }

  void getFaltante(String idTurno) async{
    clearMovimiento();
    var resultFaltante = await movimientoProvider.getMovimientoByTurno(idTurno);
    faltante = resultFaltante.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
    update();
  }

  void goToRetiroParcial(Usuario usuario) {

    Get.to(
          () => RetiroParcialPage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void  goToLiquidaciones(Usuario usuario) async{
    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientoByTurno(usuario.idTurno??'0'); //cambiar getApertura
    movimientos =  result;

    Get.to(
          () => LiquidacionesPage(usuario: usuario,movimientos:movimientos), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void goToApertura(Usuario usuario) {
    Get.to(
          () => AperturaPage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );

  }

  void goToRetiroApertura(Usuario usuario,Movimiento movimiento) {
    Get.to(
          () => RetiroAperturaPage(usuario: usuario,movimiento: movimiento), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );

  }


  void goToReportes(Usuario usuario) async{

    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientoByTurno(usuario.idTurno??''); //cambiar getApertura
    movimientos = result;
    Get.to(
          () => ReporteLiquidacion(usuario: usuario,movimientos: movimientos), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );

  }

  void goToFaltantes(Usuario usuario,int bandera) async{

    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientoByTurno(usuario.idTurno??''); //cambiar getApertura
    movimientos = result;
    Get.to(
          () => FaltantesPage(usuario: usuario,movimientos: movimientos, bandera: bandera), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );

  }




  void getEstados() async{
    var result = await estadoProvider.getAll();
    estados.clear();
    estados.addAll(result);
    update();
  }

  Future<List<Usuario>> getUsuarios(String idEstado,String idPeaje) async{
    return await usuarioProvider.findByEstadoTurno(idEstado,idPeaje);

  }


  Future<void> updateVia(String via,String idTurno) async{
    try {
      var response = await turnoProvider.updateVia(via,idTurno);
      if (response.isOk) {
        Get.snackbar('Asignado', 'La via ha sido asignada correctamente');
        getEstados();
      } else {
        Get.snackbar('Error', 'No se pudo asignar la via: ${via}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al asignar la via: $e');
    }
  }


  Future<void> deleteTurno(String idCajero) async {
    try {
      var response = await turnoProvider.eliminar(idCajero);
      if (response.isOk) {
        Get.snackbar('Eliminado', 'El turno ha sido eliminado correctamente');
       getEstados();
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al eliminar el turno: $e');
    }
  }

  Future<void> enviarTurno(String idCajero) async {
    try {
      var response = await turnoProvider.enviarTurno(idCajero);
      if (response.isOk) {
        Get.snackbar('Enviado', 'El usuario ha sido enviado a turno');
        getEstados();
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al eliminar el turno: $e');
    }
  }


  void openBottomSheet(BuildContext context, String idturno)async{
    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientoByTurno(idturno); //cambiar getApertura
    movimientos = result;

    showBarModalBottomSheet(
        context: context,
        builder: (context)=>DetalleCajero(movimientos: movimientos)
    );
  }

  void openBottomSheetLiquidacion(BuildContext context,String idturno, int bandera) async {
    List<Movimiento> movimientos = [];

      var result2 = await movimientoProvider.getMovimientoByTurno(idturno);
      var result = await movimientoProvider.getRetirosParciales(idturno);
    movimientos.addAll(result2);

    movimientos.addAll(result);

      showBarModalBottomSheet(
        context: context,
        builder: (context) => DetalleTransaccion(movimientos: movimientos, bandera: bandera),
      );

  }
}