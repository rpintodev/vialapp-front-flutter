import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';

class RetiroParcialController extends GetxController{

  MovimientoProvider movimientoProvider=MovimientoProvider();
  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  Usuario? usuario;


  TextEditingController billetes20Controller = TextEditingController();
  TextEditingController billetes10RecibeController = TextEditingController();
  TextEditingController billetes5RecibeController = TextEditingController();
  TextEditingController billetes1RecibeController = TextEditingController();



  RetiroParcialController(Usuario usuario) {
    this.usuario=usuario;

  }


  void registarRetiroParcial(BuildContext context, Usuario usuario) async {

    try {


      String recibe1D = billetes1RecibeController.text.isEmpty ? '0' : billetes1RecibeController.text;
      String recibe5D = billetes5RecibeController.text.isEmpty ? '0' : billetes5RecibeController.text;
      String recibe10D = billetes10RecibeController.text.isEmpty ? '0' : billetes10RecibeController.text;
      String recibe20D = billetes20Controller.text.isEmpty ? '0' : billetes20Controller.text;


      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(
          turno: usuario.turno,
          idturno: usuario.idTurno,
          idSupervisor: usuarioSession.id,
          idCajero: usuario.id,
          idTipoMovimiento: '2',
          idPeaje: usuarioSession.idPeaje,
          via: usuario.via,
          recibe1C: '0',
          recibe5C: '0',
          recibe10C: '0',
          recibe25C: '0',
          recibe50C: '0',
          recibe2D: '0',
          recibe1D: recibe1D,
          recibe1DB: '0',
          recibe5D: recibe5D,
          recibe10D: recibe10D,
          recibe20D: recibe20D,
          entrega1C: '0',
          entrega5C: '0',
          entrega10C: '0',
          entrega25C: '0',
          entrega50C: '0',
          entrega1D: '0',
          entrega1DB: '0',

          entrega5D: '0',
          entrega10D: '0',
          entrega20D: '0'
      );

      // Enviar la petición
      Response response = await movimientoProvider.create(movimiento);

      if (response.statusCode == 201) {
        Get.snackbar('Transacción Exitosa', 'El retiro parcial ha sido registrado');

          Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});

      } else if (response.statusCode == 400) {
        Get.snackbar('Error', 'Es posible que el cajero esté asignado');
      }
    } catch (e) {
      print('Error: $e'); // Depuración
      Get.snackbar('Error', 'Ocurrió un error inesperado');
    }
  }





}