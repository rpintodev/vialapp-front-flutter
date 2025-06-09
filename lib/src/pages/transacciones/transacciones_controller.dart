
import 'package:asistencia_vial_app/src/pages/detalle_transaccion/detalle_transaccion.dart';
import 'package:asistencia_vial_app/src/provider/provider-offline/tipomovimiento_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../helper/connection_helper.dart';
import '../../models/movimiento.dart';
import '../../models/usuario.dart';
import '../../provider/movimiento_provider.dart';

class TransaccionesController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  MovimientoProvider movimientoProvider=MovimientoProvider();

  List<Movimiento> tipoMovimientos= <Movimiento>[].obs;
  TipoMovimientoProviderOffline tipoMovimientoProviderOffline=TipoMovimientoProviderOffline();
  Movimiento movimiento=Movimiento();
  var fechaInicio = ''.obs;
  var fechaFin = ''.obs;
  var bandera = 0.obs;


  TransaccionesController(){
    fechaInicio.value='';
    fechaFin.value='';
    getTipoMovimiento();

  }



  void setFecha(bool isInicio, DateTime fecha) {
    if (isInicio) {
      fechaInicio.value = fecha.toString().substring(0, 10); // Formato YYYY-MM-DD
    } else {
      fechaFin.value = fecha.toString().substring(0, 10); // Formato YYYY-MM-DD
    }
  }




  void getTipoMovimiento() async{
    if(await isConnectedToServer()){
      var result = await movimientoProvider.getTipoMovimiento();
      await tipoMovimientoProviderOffline.saveTipoMovimientos(result);
      tipoMovimientos.clear();
      tipoMovimientos.addAll(result);
      update();
    }else{
      tipoMovimientos.assignAll(tipoMovimientoProviderOffline.getAll());
    }





  }

  Future<List<Movimiento>> getMovimientos(String fechainicio,String fechafin, String idTipoMovimiento,String idPeaje) async{
    if (fechaInicio.isNotEmpty && fechaFin.isNotEmpty) {
      print("Filtrando transacciones de ${fechaInicio.value} a ${fechaFin.value} - $idTipoMovimiento ");
      bandera.value=1;
      return await movimientoProvider.findByDateTipoMovimiento(fechaInicio.value, fechaFin.value, idTipoMovimiento, idPeaje);
    } else {
      bandera.value=0;
      return await movimientoProvider.findByTipoMovimiento(idTipoMovimiento,idPeaje);
    }

  }



  void openBottomSheet(BuildContext context, Movimiento movimiento, int bandera) async {
    List<Movimiento> movimientos = [];

    if (movimiento.idTipoMovimiento == '4') {
      movimientos.add(movimiento);
      var result = await movimientoProvider.getRetirosParciales(movimiento.idturno ?? '0');
      movimientos.addAll(result);

      showBarModalBottomSheet(
        context: context,
        builder: (context) => DetalleTransaccion(movimientos: movimientos,bandera: bandera),
      );
    } else {
      movimientos.add(movimiento); // Agrega el movimiento individual
      showBarModalBottomSheet(
        context: context,
        builder: (context) => DetalleTransaccion(movimientos: movimientos,bandera: bandera),
      );
    }
  }


}