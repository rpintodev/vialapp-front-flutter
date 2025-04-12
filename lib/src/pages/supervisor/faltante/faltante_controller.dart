import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/reporte_liquidacion.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/faltante/faltante.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../models/movimiento.dart';
import '../../../models/response_api.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';

class FaltanteController extends GetxController{

  MovimientoProvider movimientoProvider=MovimientoProvider();


  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  Usuario? usuario;
  List<Movimiento>? movimientos;
  int? bandera;
  String? pdt;

  TextEditingController simulacionesCantidadController = TextEditingController();
  TextEditingController simulacionesValorController = TextEditingController();
  TextEditingController anulacionesCantidadController = TextEditingController();
  TextEditingController anulacionesValorController = TextEditingController();
  TextEditingController sobrantesController = TextEditingController();
  final TextEditingController parteTrabajoController = TextEditingController();

  RxBool isFaltanteVisible = false.obs;
  //ENTRGA
  TextEditingController billetes20ControllerE = TextEditingController();
  TextEditingController billetes10ControllerE = TextEditingController();
  TextEditingController billetes5ControllerE = TextEditingController();
  TextEditingController billetes1ControllerE = TextEditingController();
  TextEditingController Moneda50ControllerE = TextEditingController();
  TextEditingController Moneda25ControllerE = TextEditingController();
  TextEditingController Moneda10ControllerE = TextEditingController();
  TextEditingController Moneda5ControllerE = TextEditingController();

  //RECIBE
  TextEditingController billetes20ControllerR = TextEditingController();
  TextEditingController billetes10ControllerR = TextEditingController();
  TextEditingController billetes5ControllerR= TextEditingController();
  TextEditingController billetes1ControllerR = TextEditingController();
  TextEditingController Moneda50ControllerR = TextEditingController();
  TextEditingController Moneda25ControllerR = TextEditingController();
  TextEditingController Moneda10ControllerR = TextEditingController();
  TextEditingController Moneda5ControllerR = TextEditingController();
  late String idmovimiento;


  FaltanteController(List<Movimiento> movimientos,int bandera) {
    this.usuario=usuario;
    this.movimientos=movimientos;
    this.bandera=bandera;

    final liquidacion1 = movimientos.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
    final faltante =  movimientos.firstWhere((m) => m.idTipoMovimiento == '6', orElse: () => Movimiento());
    final apertura= movimientos.firstWhere((m)=> m.idTipoMovimiento=='1', orElse: () => Movimiento());
    String formattedFechaHoy=DateFormat('ddMMyyyy').format(DateTime.parse(apertura.fecha??''));
    pdt='${apertura.via??'0'}$formattedFechaHoy';



    parteTrabajoController.text = liquidacion1.partetrabajo?.toString() ?? pdt??'';
    simulacionesCantidadController.text = liquidacion1.simulaciones?.toString() ?? '';
    simulacionesValorController.text = liquidacion1.valorsimulaciones?.toString() ?? '';
    anulacionesCantidadController.text = liquidacion1.anulaciones?.toString() ?? '';
    anulacionesValorController.text = liquidacion1.valoranulaciones?.toString() ?? '';
    sobrantesController.text = liquidacion1.sobrante?.toString() ?? '';

    faltante.entrega20D=='0'?faltante.entrega20D='':billetes20ControllerE.text = faltante.entrega20D??'';
    faltante.entrega10D=='0'?faltante.entrega10D='':billetes10ControllerE.text = faltante.entrega10D??'';
    faltante.entrega5D=='0'?faltante.entrega5D='':billetes5ControllerE.text = faltante.entrega5D??'';
    faltante.entrega1D=='0'?faltante.entrega1D='':billetes1ControllerE.text = faltante.entrega1D??'';
    faltante.entrega50C=='0'?faltante.entrega50C='':Moneda50ControllerE.text = faltante.entrega50C??'';
    faltante.entrega25C=='0'?faltante.entrega25C='':Moneda25ControllerE.text = faltante.entrega25C??'';
    faltante.entrega10C=='0'?faltante.entrega10C='':Moneda10ControllerE.text = faltante.entrega10C??'';
    faltante.entrega5C=='0'?faltante.entrega5C='':Moneda5ControllerE.text = faltante.entrega5C??'';

    faltante.recibe20D=='0'?faltante.recibe20D='':billetes20ControllerR.text = faltante.recibe20D??'';
    faltante.recibe10D=='0'?faltante.recibe10D='':billetes10ControllerR.text = faltante.recibe10D??'';
    faltante.recibe5D=='0'?faltante.recibe5D='':billetes5ControllerR.text = faltante.recibe5D??'';
    faltante.recibe1D=='0'?faltante.recibe1D='':billetes1ControllerR.text = faltante.recibe1D??'';
    faltante.recibe50C=='0'?faltante.recibe50C='':Moneda50ControllerE.text = faltante.recibe50C??'';
    faltante.recibe25C=='0'?faltante.recibe25C='':Moneda25ControllerE.text = faltante.recibe25C??'';
    faltante.recibe10C=='0'?faltante.recibe10C='':Moneda10ControllerE.text = faltante.recibe10C??'';
    faltante.recibe5C=='0'?faltante.recibe5C='':Moneda5ControllerE.text = faltante.recibe5C??'';

    idmovimiento=faltante.id?.toString()??'0';

  }



  void actualizarLiquidacion(BuildContext context,List<Movimiento> movimientos) async {

    final liquidacion = movimientos.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
    final primerMovimiento= movimientos.firstWhere((m)=> m.idTipoMovimiento=='1', orElse: () => Movimiento());

    try {

      String recibe5C = Moneda5ControllerR.text.isEmpty ? '0' : Moneda5ControllerR.text;
      String recibe10C = Moneda10ControllerR.text.isEmpty ? '0' : Moneda10ControllerR.text;
      String recibe25C = Moneda25ControllerR.text.isEmpty ? '0' : Moneda25ControllerR.text;
      String recibe50C= Moneda50ControllerR.text.isEmpty ? '0' : Moneda50ControllerR.text;
      String recibe1D = billetes1ControllerR.text.isEmpty ? '0' : billetes1ControllerR.text;
      String recibe5D = billetes5ControllerR.text.isEmpty ? '0' : billetes5ControllerR.text;
      String recibe10D = billetes10ControllerR.text.isEmpty ? '0' : billetes10ControllerR.text;
      String recibe20D = billetes20ControllerR.text.isEmpty ? '0' : billetes20ControllerR.text;

      String entrega5C = Moneda5ControllerE.text.isEmpty ? '0' : Moneda5ControllerE.text;
      String entrega10C = Moneda10ControllerE.text.isEmpty ? '0' : Moneda10ControllerE.text;
      String entrega25C = Moneda25ControllerE.text.isEmpty ? '0' : Moneda25ControllerE.text;
      String entrega50C= Moneda50ControllerE.text.isEmpty ? '0' : Moneda50ControllerE.text;
      String entrega1D = billetes1ControllerE.text.isEmpty ? '0' : billetes1ControllerE.text;
      String entrega5D = billetes5ControllerE.text.isEmpty ? '0' : billetes5ControllerE.text;
      String entrega10D = billetes10ControllerE.text.isEmpty ? '0' : billetes10ControllerE.text;
      String entrega20D = billetes20ControllerE.text.isEmpty ? '0' : billetes20ControllerE.text;


      String anulaciones = anulacionesCantidadController.text.isEmpty?'':anulacionesCantidadController.text;
      String valoranulaciones = anulacionesValorController.text.isEmpty?'':anulacionesValorController.text;
      String simulaciones = simulacionesCantidadController.text.isEmpty?'':simulacionesCantidadController.text;
      String valorsimulaciones = simulacionesValorController.text.isEmpty?'':simulacionesValorController.text;
      String sobrante = sobrantesController.text.isEmpty?'':sobrantesController.text;
      String partetrabajo = parteTrabajoController.text.isEmpty?'':parteTrabajoController.text;

      // Calcular la suma total de "Recibido"
      double totalRecibido = (double.parse(recibe5C) * 0.05) +
          (double.parse(recibe10C) * 0.10) +
          (double.parse(recibe25C) * 0.25) +
          (double.parse(recibe50C) * 0.50) +
          double.parse(recibe1D) +
          (double.parse(recibe5D) * 5) +
          (double.parse(recibe10D) * 10) +
          (double.parse(recibe20D) * 20);

      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(
          turno: primerMovimiento.turno,
          idturno: primerMovimiento.idturno,
          idSupervisor: usuarioSession.id,
          idCajero: primerMovimiento.idCajero,
          idTipoMovimiento: '6',
          via: primerMovimiento.via,
          idPeaje: usuarioSession.idPeaje,
          recibe1C: '0',
          partetrabajo: '0',
          recibe5C: recibe5C,
          recibe10C: recibe10C,
          recibe25C: recibe25C,
          recibe50C: recibe50C,
          recibe1DB: '0',
          recibe1D: recibe1D,
          recibe2D: '0',
          recibe5D: recibe5D,
          recibe10D: recibe10D,
          recibe20D: recibe20D,
          entrega1C: '0',
          entrega5C: entrega5C,
          entrega10C: entrega10C,
          entrega25C: entrega25C,
          entrega50C: entrega50C,
          entrega1DB: '0',
          entrega1D: entrega1D,
          entrega5D: entrega5D,
          entrega10D: entrega10D,
          entrega20D: entrega20D
      );

      Movimiento movimiento2 = Movimiento(
          id: liquidacion.id,
          idSupervisor: usuarioSession.id,
          partetrabajo: partetrabajo,
          anulaciones: anulaciones,
          valoranulaciones: valoranulaciones,
          simulaciones: simulaciones,
          valorsimulaciones: valorsimulaciones,
          sobrante: sobrante

      );

      Movimiento movimiento3 = Movimiento(
          turno: primerMovimiento.turno,
          idturno: primerMovimiento.idturno,
          idSupervisor: usuarioSession.id,
          idCajero: primerMovimiento.idCajero,
          idTipoMovimiento: '4',
          via: primerMovimiento.via,
          idPeaje: usuarioSession.idPeaje,
          partetrabajo: partetrabajo,
          recibe1C: '0',
          recibe5C: recibe5C,
          recibe10C: recibe10C,
          recibe25C: recibe25C,
          recibe50C: recibe50C,
          recibe1DB: '0',
          recibe1D: recibe1D,
          recibe2D: '0',
          recibe5D: recibe5D,
          recibe10D: recibe10D,
          recibe20D: recibe20D,
          entrega1C: '0',
          entrega5C: entrega5C,
          entrega10C: entrega10C,
          entrega25C: entrega25C,
          entrega50C: entrega50C,
          entrega1DB: '0',
          entrega1D: entrega1D,
          entrega5D: entrega5D,
          entrega10D: entrega10D,
          entrega20D: entrega20D,
          sobrante: '',
      );

      Movimiento movimiento4 = Movimiento(
          id:idmovimiento,
          turno: primerMovimiento.turno,
          idturno: primerMovimiento.idturno,
          idSupervisor: usuarioSession.id,
          idCajero: primerMovimiento.idCajero,
          idTipoMovimiento: '6',
          via: primerMovimiento.via,
          idPeaje: usuarioSession.idPeaje,
          recibe1C: '0',
          partetrabajo: '0',
          recibe5C: recibe5C,
          recibe10C: recibe10C,
          recibe25C: recibe25C,
          recibe50C: recibe50C,
          recibe1DB: '0',
          recibe1D: recibe1D,
          recibe2D: '0',
          recibe5D: recibe5D,
          recibe10D: recibe10D,
          recibe20D: recibe20D,
          entrega1C: '0',
          entrega5C: entrega5C,
          entrega10C: entrega10C,
          entrega25C: entrega25C,
          entrega50C: entrega50C,
          entrega1DB: '0',
          entrega1D: entrega1D,
          entrega5D: entrega5D,
          entrega10D: entrega10D,
          entrega20D: entrega20D
      );


      if(bandera==1){//GUARDA EL PARTE DE TRABAJO
        Response response = await movimientoProvider.create(movimiento3);

        if (response.statusCode == 201) {
          Get.snackbar('Guardado', 'El parte de trabajo ha sido guardado');
          Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});

        } else if (response.statusCode == 400) {
          Get.snackbar('Error','');
          Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});


        }
      }else{ //
      if (totalRecibido > 0) {

        if(idmovimiento=='0'){//SI SE CREA UN NUEVO FALTANTE

          Response response = await movimientoProvider.create(movimiento);

          ResponseApi responseApi = await movimientoProvider.updateLiquidacion(movimiento2);

          if(responseApi.success==true && response.statusCode == 201){

            Get.snackbar('Liquidacion existosa', 'La liquidacion ha sido actualizada se añadio el faltante');
            var result = await movimientoProvider.getMovimientoByTurno(primerMovimiento.idturno??''); //cambiar getApertura
            movimientos = result;
            Get.off(
                  () => ReporteLiquidacion(movimientos: movimientos), // Página a la que navegas
              arguments: usuario,
            );
          }else{
            Get.snackbar('ERROR', responseApi.message??'');
          }

        }else{ //SI SE MODIFICA EL FALTANTE
          ResponseApi responseApi = await movimientoProvider.updateLiquidacion(movimiento2);
          ResponseApi responseapi2 = await movimientoProvider.update(movimiento4);

          if(responseApi.success==true && responseapi2.success==true){

            Get.snackbar('Liquidacion existosa', 'La liquidacion ha sido modificada');
            var result = await movimientoProvider.getMovimientoByTurno(primerMovimiento.idturno??''); //cambiar getApertura
            movimientos = result;
            Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
          }else{
            Get.snackbar('ERROR ', responseApi.message??'');

          }

        }


      }else{ //SI EL PARTE DE TRABAJO SE HA GUARDADO Y SE VA AGREGAR ANULACIONES Y SIMULACIONES...

        ResponseApi responseApi = await movimientoProvider.updateLiquidacion(movimiento2);

        if(responseApi.success==true){


          Get.snackbar('Liquidacion existosa', 'La liquidacion ha sido actualizada ${movimiento2.sobrante}');
          var result = await movimientoProvider.getMovimientoByTurno(primerMovimiento.idturno??''); //cambiar getApertura
          movimientos = result;
          Get.off(
                () => ReporteLiquidacion(movimientos: movimientos), // Página a la que navegas
            arguments: usuario, // Envía el objeto Usuario como argumento
          );

        }else{
          Get.snackbar('ERROR ', responseApi.message??'');

        }
      }
      }


    } catch (e) {
      print('Error: $e'); // Depuración
      Get.snackbar('Error', 'Ocurrió un error inesperado');
    }
  }







}