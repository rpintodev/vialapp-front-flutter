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
import 'package:asistencia_vial_app/src/provider/provider-offline/usuario_provider_offline.dart';
import 'package:asistencia_vial_app/src/provider/turno_provider.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../environment/environment.dart';
import '../../../helper/connection_helper.dart';
import '../../../models/usuario.dart';
import '../../../provider/provider-offline/estado_provider_offline.dart';
import '../../../provider/provider-offline/movimiento_provider_offline.dart';
import '../../detalle_transaccion/detalle_transaccion.dart';

class AsignacionController extends GetxController{

  Socket socket = io('${Environment.API_URL}',<String,dynamic>{
    'transports':['websocket'],
    'autoConnect':false
  });

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});
  EstadoProvider estadoProvider=EstadoProvider();
  MovimientoProvider movimientoProvider=MovimientoProvider();
  UsuarioProvider usuarioProvider=UsuarioProvider();
  TurnoProvider turnoProvider=TurnoProvider();
  UsuarioProviderOffline usuarioOffline = UsuarioProviderOffline();
  EstadoProviderOffline estadoOffline = EstadoProviderOffline();
  MovimientoProviderOffline movimientoOffline = MovimientoProviderOffline();
  var estados = <Estado>[].obs;


  Movimiento movimiento=Movimiento();
  Movimiento faltante=Movimiento();

   AsignacionController(){

   getEstados();
   connectAndListenSocket();
  }


  void connectAndListenSocket() {
    socket.connect();
    socket.onConnect((_) {
      print('Asignacion conectado al socket');
    });
    listenEstadoCajero();
  }

  void listenEstadoCajero (){
    socket.on('actualizar_turno', (data) {
      print('Se recibió actualización de estado por socket: $data');

      getEstados(); // O getUsuarios si ya tienes el estado seleccionado

    });
  }

  void clearMovimiento() {
    movimiento = Movimiento();
    faltante= Movimiento();// Restablece a un objeto vacío
    update(); // Notifica a las vistas que el estado ha cambiado
  }




  void goToCanje(Usuario usuario) async{

    Get.to(
          () => CanjePage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void getApertura(String idTurno) async{
     if(await isConnectedToServer()) {
       clearMovimiento();
       var result = await movimientoProvider.getApertura(idTurno);
       movimiento = result!;
       update();
     }else{
       movimiento = movimientoOffline.getApertura(idTurno);
     }
  }

  Future<List<Movimiento?>> getMovimientoPorUsuario(String idTurno) async {
     List<Movimiento> movimientos;

    if(await isConnectedToServer()){

      movimientos = await movimientoProvider.getMovimientoByTurno(idTurno); //cambiar getApertura
      await movimientoOffline.saveMovimientos(movimientos);
      return movimientos;

    }else{
      return movimientoOffline.getMovimientoByTurno(idTurno);
    }

  }

  void getFaltante(String idTurno) async{

    if(await isConnectedToServer()){

      clearMovimiento();
      var resultFaltante = await movimientoProvider.getMovimientoByTurno(idTurno);
      faltante = resultFaltante.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
      update();

    }else{
      faltante = movimientoOffline.getMovimientoByTurno(idTurno).firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
    }


  }

  void goToRetiroParcial(Usuario usuario) {

    Get.to(
          () => RetiroParcialPage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void  goToLiquidaciones(Usuario usuario) async{
    List<Movimiento>? movimientos;

    if(await isConnectedToServer()){
      movimientos = await movimientoProvider.getMovimientoByTurno(usuario.idTurno??'0'); //cambiar getApertura
    }else{
      movimientos= movimientoOffline.getMovimientoByTurno(usuario.idTurno??'0');
    }


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

  void goToRetiroApertura(Usuario usuario,Movimiento movimiento) async{
    if(!await isConnectedToServer()){
      movimiento = await movimientoOffline.getApertura(movimiento.idturno??'');
    }
    print('Id Apertura: ${movimiento.id}');
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
          () => ReporteLiquidacion(movimientos: movimientos), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );

  }

  void goToFaltantes(Usuario usuario,int bandera) async{

    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientoByTurno(usuario.idTurno??''); //cambiar getApertura
    movimientos = result;
    Get.to(
          () => FaltantesPage(movimientos: movimientos, bandera: bandera), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );

  }


  void getEstados() async{

     if(await isConnectedToServer()){
       var result = await estadoProvider.getAll();
       estados.assignAll(result);
       estadoOffline.saveEstados(result);
     }else{
       estados.assignAll(estadoOffline.getAll());
     }


  }

  Future<List<Usuario>> getUsuarios(String idEstado, String idPeaje) async {
    if(await isConnectedToServer()){
      List<Usuario> response= await usuarioProvider.findByEstadoTurno(idEstado, idPeaje);
      await usuarioOffline.saveUsuarios(response);
      return response;
    }else{

      final response= usuarioOffline.findByEstadoTurno(idEstado, idPeaje);
        print('Numero de usuarios: ${response.length}');
      
      return response;
    }

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

  Future<void> enviarBoveda(String idCajero,String idTurno) async {
    try {
      var response = await turnoProvider.enviarBoveda(idCajero,idTurno);
      if (response.isOk) {
        Get.snackbar('Enviado', 'El usuario ha sido enviado a Boveda');
        getEstados();
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al enviar a Boveda: $e');
    }
  }


  void openBottomSheet(BuildContext context, String idturno)async{
    List<Movimiento>? movimientos;

    if(await isConnectedToServer()){
       movimientos = await movimientoProvider.getMovimientoByTurno(idturno); //cambiar getApertura
     }else{
       movimientos = movimientoOffline.getMovimientoByTurno(idturno);
     }


    showBarModalBottomSheet(
        context: context,
        builder: (context)=>DetalleCajero(movimientos: movimientos)
    );
  }

  void openBottomSheetLiquidacion(BuildContext context,String idturno, int bandera) async {
    List<Movimiento>? movimientos;

    if(await isConnectedToServer()){
      movimientos = await movimientoProvider.getMovimientoByTurno(idturno); //cambiar getApertura
    }else{
      movimientos = movimientoOffline.getMovimientoByTurno(idturno);
    }

    showBarModalBottomSheet(
        context: context,
        builder: (context) => DetalleTransaccion(movimientos: movimientos, bandera: bandera),
      );

  }



}