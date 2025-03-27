
import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:asistencia_vial_app/src/pages/admin/modificar_boveda/modificar_boveda.dart';
import 'package:asistencia_vial_app/src/pages/reportes/informe_boveda/informe_boveda.dart';
import 'package:asistencia_vial_app/src/pages/reportes/informe_boveda_actual/informe_boveda_actual.dart';
import 'package:asistencia_vial_app/src/pages/reportes/recaudaciones_parciales/reporte_recaudaciones.dart';
import 'package:asistencia_vial_app/src/provider/boveda_provider.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:asistencia_vial_app/src/provider/peaje_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../models/movimiento.dart';
import '../../models/response_api.dart';
import '../../models/usuario.dart';
import '../../provider/usuario_provider.dart';
import '../supervisor/canje_fortius/canje_fortius.dart';
import '../supervisor/retiro_fortius/retiro_fortius.dart';

class BovedaController extends GetxController{
  Usuario usuarioSessio = Usuario.fromJson(GetStorage().read('usuario')??{});
  PeajeProvider peajeProvider=PeajeProvider();
  MovimientoProvider movimientoProvider=MovimientoProvider();

  late String idPeajeSeleccionado;

  BovedaProvider bovedaProvider = BovedaProvider();
  var boveda = Rx<Boveda?>(null);
  int? retiro;


  void signOut(){
    GetStorage().remove('usuario');
    Get.offNamedUntil('/',(route)=>false);

  }




  void getBoveda(String idpeaje) async{
    if(usuarioSessio.roles?.first.id =='4'){
      var result= await bovedaProvider.getSecreBoveda(idpeaje);
      boveda.value = result;
    }else {
      var result = await bovedaProvider.getAll(idpeaje);
      boveda.value = result;
    }

    update();
  }

  void goToRetiroFortius(Usuario usuario) {
    Get.to(
          () => RetiroFortiusPage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void goToCanjeFortius(Usuario usuario) {
    Get.to(
          () => CanjeFortiusPage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  void gotoProfile(){
    Get.toNamed('/profile/info');
  }


  void goToReporteRecaudaciones(Usuario usuario) async{

    List<Movimiento>? movimientos;
    var result = await movimientoProvider.getMovimientosReporteRetiros(usuarioSessio.idPeaje??''); //cambiar getApertura
    movimientos = result;
    Get.to(
          () => ReporteRecaudaciones(usuario: usuario,movimientos: movimientos),
      arguments: usuario,
    );
  }

  void goToInformeBoveda(Boveda boveda, int retiro) async {
    List<Boveda> bovedas=[];
    var result4= await bovedaProvider.getSecreBoveda(usuarioSessio.idPeaje ?? '');

    bovedas.add(result4!);
    bovedas.add(boveda);

    List<Movimiento>? movimientos = await movimientoProvider.getRetirosParcialesByDateActual(usuarioSessio.idPeaje ?? '');

    var result = await movimientoProvider.getAperturasByDate(usuarioSessio.idPeaje ?? '' );
    movimientos.addAll(result);

    var result2 = await movimientoProvider.getLiquidacionesByDate(usuarioSessio.idPeaje ?? '');
    movimientos.addAll(result2);

    var result3 = await movimientoProvider.getFortiusByDateActual(usuarioSessio.idPeaje ?? '');
    movimientos.addAll(result3);

    Get.to(
          () => InformeBoveda(bovedas: bovedas, movimientos: movimientos),
      arguments: boveda,
    );
  }


  void goToInformeBovedaActual(Boveda boveda, int retiro) async {
    List<Boveda> bovedas=[];
    var result4= await bovedaProvider.getSecreBoveda(usuarioSessio.idPeaje ?? '');

    bovedas.add(result4!);
    bovedas.add(boveda);

    List<Movimiento>? movimientos = await movimientoProvider.getRetirosParcialesByDateActual(usuarioSessio.idPeaje ?? '');

    var result = await movimientoProvider.getAperturasByDate(usuarioSessio.idPeaje ?? '' );
    movimientos.addAll(result);

    var result2 = await movimientoProvider.getLiquidacionesByDate(usuarioSessio.idPeaje ?? '');
    movimientos.addAll(result2);

    var result3 = await movimientoProvider.getFortiusByDateActual(usuarioSessio.idPeaje ?? '');
    movimientos.addAll(result3);

    Get.to(
          () => InformeBovedaActual(bovedas: bovedas, movimientos: movimientos),
      arguments: boveda,
    );
  }


  void goToModificarBoveda(Boveda boveda) {
    Get.to(
          () => ModificarBoveda(boveda: boveda), // Página a la que navegas
      arguments: boveda, // Envía el objeto Usuario como argumento
    );
  }


  void actualizarPeaje(BuildContext context,String idpeaje) async{


      ProgressDialog progressDialog=ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando peaje..');

      Usuario usuario=Usuario(
        id: usuarioSessio.id,
        idPeaje: idpeaje,
        usuario: usuarioSessio.usuario,
        sessionToken: usuarioSessio.sessionToken

       );

        ResponseApi responseApi = await peajeProvider.update(usuario);
        print('Response Api Data: ${responseApi.data}');
        progressDialog.close();

        if(responseApi.success ==true){
          GetStorage().write('usuario', responseApi.data);
          Get.snackbar('Actualizacion Existosa', 'El usuario ha sido actualizado');
          Get.offNamedUntil('/home', (route)=>false);

        }else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }



  }

  void depositoBoveda(BuildContext context,String idpeaje) async{


    ProgressDialog progressDialog=ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Actualizando boveda..');



    ResponseApi responseApi = await bovedaProvider.depositoBoveda(idpeaje);
    print('Response Api Data: ${responseApi.data}');
    progressDialog.close();

    if(responseApi.success ==true){
      Get.snackbar('Actualizacion Existosa', 'La boveda ha sido actualizado');
      Get.offNamedUntil('/home', (route)=>false);

    }else {
      Get.snackbar('Actualización fallido', responseApi.message ?? '');
    }



  }


}