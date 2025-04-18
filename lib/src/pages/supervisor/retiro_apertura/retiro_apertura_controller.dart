import 'package:asistencia_vial_app/src/models/response_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';

class RetiroAperturaController extends GetxController{

  MovimientoProvider movimientoProvider=MovimientoProvider();
  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});


  TextEditingController billetes20Controller = TextEditingController();
  TextEditingController billetes10RecibeController = TextEditingController();
  TextEditingController billetes5RecibeController = TextEditingController();
  TextEditingController Moneda50RecibeController = TextEditingController();
  TextEditingController Moneda25RecibeController = TextEditingController();
  TextEditingController Moneda10RecibeController = TextEditingController();
  TextEditingController Moneda5RecibeController = TextEditingController();
  TextEditingController Moneda1RecibeController = TextEditingController();
  TextEditingController billetes1RecibeController = TextEditingController();
  TextEditingController billetes10EntregaController = TextEditingController();
  TextEditingController billetes5EntregaController = TextEditingController();
  TextEditingController billetes1EntregaController = TextEditingController();
  TextEditingController Moneda50EntregaController = TextEditingController();
  TextEditingController Moneda25EntregaController = TextEditingController();
  TextEditingController Moneda10EntregaController = TextEditingController();
  TextEditingController Moneda5EntregaController = TextEditingController();
  TextEditingController Moneda1EntregaController = TextEditingController();
   late String idmovimiento;
   late String via;

  Usuario? usuario;
  Movimiento? movimiento;

  RxDouble Entregado = 0.0.obs;
  RxDouble Recibido = 0.0.obs;


  RxBool enProgreso = false.obs;
  RxBool aperturaCompleta = false.obs;


  void verificarApertura() {
    enProgreso.value = true;

    final totalEntregado = (int.tryParse(billetes10EntregaController.text) ?? 0) * 10 +
        (int.tryParse(billetes5EntregaController.text) ?? 0) * 5 +
        (int.tryParse(billetes1EntregaController.text) ?? 0) * 1+
    ((int.tryParse(Moneda50EntregaController.text) ?? 0) * 0.5).toDouble()+
    ((int.tryParse(Moneda25EntregaController.text) ?? 0) * 0.25).toDouble()+
    ((int.tryParse(Moneda10EntregaController.text) ?? 0) * 0.5).toDouble()+
    ((int.tryParse(Moneda5EntregaController.text) ?? 0) * 0.05).toDouble()+
    ((int.tryParse(Moneda5EntregaController.text) ?? 0) * 0.01).toDouble();

    final totalRecibido = (int.tryParse(billetes20Controller.text) ?? 0) * 20 +
        (int.tryParse(billetes10RecibeController.text) ?? 0) * 10 +
        (int.tryParse(billetes5RecibeController.text) ?? 0) * 5 +
        (int.tryParse(billetes1RecibeController.text) ?? 0) * 1+
        ((int.tryParse(Moneda50RecibeController.text) ?? 0) * 0.5).toDouble()+
        ((int.tryParse(Moneda25RecibeController.text) ?? 0) * 0.25).toDouble()+
        ((int.tryParse(Moneda10RecibeController.text) ?? 0) * 0.5).toDouble()+
        ((int.tryParse(Moneda5RecibeController.text) ?? 0) * 0.05).toDouble()+
        ((int.tryParse(Moneda5RecibeController.text) ?? 0) * 0.01).toDouble();

    aperturaCompleta.value = (totalEntregado - totalRecibido) == 0;
    Entregado.value = totalEntregado;
    Recibido.value = totalRecibido;

    // Si apertura está completa, deshabilitar los campos y ocultar el botón
    if (aperturaCompleta.value) {
      enProgreso.value = false;
    }
  }



  RetiroAperturaController(Usuario usuario, Movimiento movimiento) {
    this.usuario=usuario;
    this.movimiento=movimiento;

    billetes10EntregaController.text = movimiento.entrega10D?.toString() ?? '0';
    billetes5EntregaController.text = movimiento.entrega5D?.toString() ?? '0';
    billetes1EntregaController.text = movimiento.entrega1D?.toString() ?? '0';
    Moneda50EntregaController.text = movimiento.entrega50C?.toString() ?? '0';
    Moneda25EntregaController.text = movimiento.entrega25C?.toString() ?? '0';
    Moneda5EntregaController.text = movimiento.entrega10C?.toString() ?? '0';
    Moneda10EntregaController.text = movimiento.entrega5C?.toString() ?? '0';
    Moneda1EntregaController.text = movimiento.entrega1C?.toString() ?? '0';
    movimiento.recibe20D=='0'?movimiento.recibe20D='':billetes20Controller.text = movimiento.recibe20D??'';
    movimiento.recibe10D=='0'?movimiento.recibe10D='':billetes10RecibeController.text = movimiento.recibe10D??'';
    movimiento.recibe5D=='0'?movimiento.recibe5D='':billetes5RecibeController.text = movimiento.recibe5D??'';
    movimiento.recibe1D=='0'?movimiento.recibe1D='':billetes1RecibeController.text = movimiento.recibe1D??'';
    movimiento.recibe50C=='0'?movimiento.recibe50C='':Moneda50RecibeController.text = movimiento.recibe50C??'';
    movimiento.recibe25C=='0'?movimiento.recibe25C='':Moneda25RecibeController.text = movimiento.recibe25C??'';
    movimiento.recibe10C=='0'?movimiento.recibe10C='':Moneda10RecibeController.text = movimiento.recibe10C??'';
    movimiento.recibe5C=='0'?movimiento.recibe5C='':Moneda5RecibeController.text = movimiento.recibe5C??'';
    movimiento.recibe1C=='0'?movimiento.recibe1C='':Moneda1RecibeController.text = movimiento.recibe1C??'';

    idmovimiento=movimiento.id?.toString()??'0';
    via=movimiento.via?.toString()??'0';


  }


  void registarRetiroApertura(BuildContext context, Usuario usuario,Movimiento movimientos) async {

    try {

      String entrega10D = billetes10EntregaController.text.isEmpty ? '0' : billetes10EntregaController.text;
      String entrega5D = billetes5EntregaController.text.isEmpty ? '0' : billetes5EntregaController.text;
      String entrega1D = billetes1EntregaController.text.isEmpty ? '0' : billetes1EntregaController.text;
      String entrega50C = Moneda50EntregaController.text.isEmpty ? '0' : Moneda50EntregaController.text;
      String entrega25C = Moneda25EntregaController.text.isEmpty ? '0' : Moneda25EntregaController.text;
      String entrega10C = Moneda10EntregaController.text.isEmpty ? '0' : Moneda10EntregaController.text;
      String entrega5C = Moneda5EntregaController.text.isEmpty ? '0' : Moneda5EntregaController.text;
      String entrega1C = Moneda1EntregaController.text.isEmpty ? '0' : Moneda1EntregaController.text;


      String recibe1D = billetes1RecibeController.text.isEmpty ? '0' : billetes1RecibeController.text;
      String recibe5D = billetes5RecibeController.text.isEmpty ? '0' : billetes5RecibeController.text;
      String recibe10D = billetes10RecibeController.text.isEmpty ? '0' : billetes10RecibeController.text;
      String recibe20D = billetes20Controller.text.isEmpty ? '0' : billetes20Controller.text;
      String recibe50C = Moneda50RecibeController.text.isEmpty ? '0' : Moneda50RecibeController.text;
      String recibe25C = Moneda25RecibeController.text.isEmpty ? '0' : Moneda25RecibeController.text;
      String recibe10C = Moneda10RecibeController.text.isEmpty ? '0' : Moneda10RecibeController.text;
      String recibe5C = Moneda5RecibeController.text.isEmpty ? '0' : Moneda5RecibeController.text;
      String recibe1C = Moneda1RecibeController.text.isEmpty ? '0' : Moneda1RecibeController.text;


      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(
          id: idmovimiento,
          via: via,
          entrega20D: '0',
          entrega10D: entrega10D,
          entrega5D: entrega5D,
          entrega1D: entrega1D,
          entrega50C: entrega50C,
          entrega25C: entrega25C,
          entrega10C: entrega10C,
          entrega5C: entrega5C,
          entrega1C: entrega1C,
          recibe1C: recibe1C,
          recibe5C: recibe5C,
          recibe10C: recibe10C,
          recibe25C: recibe25C,
          recibe50C: recibe50C,
          recibe1D: recibe1D,
          recibe5D: recibe5D,
          recibe10D: recibe10D,
          recibe20D: recibe20D

      );

      // Enviar la petición
      ResponseApi responseApi = await movimientoProvider.update(movimiento);

      if(responseApi.success==true){
        Get.snackbar('Retiro de apertura existosa', 'La apertura ha sido retirada');
        Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
      }else{
        Get.snackbar('ERROR ', responseApi.message??'');

      }
    } catch (e) {
      print('Error: $e'); // Depuración
      Get.snackbar('Error', 'Ocurrió un error inesperado');
    }
  }






}