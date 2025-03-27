import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:asistencia_vial_app/src/provider/boveda_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';
import '../../detalle_transaccion/detalle_transaccion.dart';

class TransaccionesSecrecontroller extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  MovimientoProvider movimientoProvider=MovimientoProvider();
  BovedaProvider bovedaProvider=BovedaProvider();
  List<Movimiento> tipoMovimientos= <Movimiento>[].obs;
  Boveda boveda=Boveda();

  Movimiento movimiento=Movimiento();


  var fechaInicio = ''.obs;
  var fechaFin = ''.obs;

  TransaccionesController(){
    if(boveda.total=='0'){
      fechaInicio.value=boveda.fecha!;

    }else{
      fechaInicio.value='';

    }
    fechaFin.value='';
  }

  void getBoveda(String idpeaje) async{

      var result= await bovedaProvider.getSecreBoveda(idpeaje);
      boveda = result!;
      update();
  }


  void setFecha(bool isInicio, DateTime fecha) {
    if (isInicio) {
      fechaInicio.value = fecha.toString().substring(0, 10); // Formato YYYY-MM-DD
    } else {
      fechaFin.value = fecha.toString().substring(0, 10); // Formato YYYY-MM-DD
    }
  }

  Future<List<Movimiento>> getMovimientos(String fechainicio,String fechafin, String idTipoMovimiento,String idPeaje) async{
    if (fechaInicio.isNotEmpty && fechaFin.isNotEmpty) {
      print("Filtrando transacciones de ${fechaInicio.value} a ${fechaFin.value} - $idTipoMovimiento ");
      // return await movimientoProvider.findByTipoMovimiento(idTipoMovimiento,idPeaje);

      return await movimientoProvider.findByDateTipoMovimiento(fechaInicio.value, fechaFin.value, idTipoMovimiento, idPeaje);
    } else {
      return await movimientoProvider.findByTipoMovimiento(idTipoMovimiento,idPeaje);
    }

  }

  void openBottomSheet(BuildContext context, Movimiento movimiento) async {
    List<Movimiento> movimientos = [];

         movimientos.add(movimiento); // Agrega el movimiento individual
        showBarModalBottomSheet(
        context: context,
        builder: (context) => DetalleTransaccion(movimientos: movimientos),
      );

  }


}