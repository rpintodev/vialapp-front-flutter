import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';

class RetiroFortiusController extends GetxController{

  MovimientoProvider movimientoProvider=MovimientoProvider();
  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  Usuario? usuario;
  final selectedTurno = 0.obs;


  TextEditingController billetes20Controller = TextEditingController();
  TextEditingController billetes10EntregaController = TextEditingController();
  TextEditingController billetes5EntregaController = TextEditingController();
  TextEditingController billetes1EntregaController = TextEditingController();
  TextEditingController Moneda50EntregaController = TextEditingController();
  TextEditingController Moneda25EntregaController = TextEditingController();
  TextEditingController Moneda10EntregaController = TextEditingController();
  TextEditingController Moneda5EntregaController = TextEditingController();
  TextEditingController Moneda1EntregaController = TextEditingController();



  RetiroFortiusController(Usuario usuario) {
    this.usuario=usuario;

  }


  void registarRetiroParcial(BuildContext context, Usuario usuario) async {

    try {

      DateTime now = DateTime.now();
      String turno=selectedTurno.value.toString();



      String entrega1C = Moneda1EntregaController.text.isEmpty ? '0' : Moneda1EntregaController.text;
      String entrega5C = Moneda5EntregaController.text.isEmpty ? '0' : Moneda5EntregaController.text;
      String entrega10C = Moneda10EntregaController.text.isEmpty ? '0' : Moneda10EntregaController.text;
      String entrega25C = Moneda25EntregaController.text.isEmpty ? '0' : Moneda25EntregaController.text;
      String entrega50C = Moneda50EntregaController.text.isEmpty ? '0' : Moneda50EntregaController.text;
      String entrega1D = billetes1EntregaController.text.isEmpty ? '0' : billetes1EntregaController.text;
      String entrega5D = billetes5EntregaController.text.isEmpty ? '0' : billetes5EntregaController.text;
      String entrega10D = billetes10EntregaController.text.isEmpty ? '0' : billetes10EntregaController.text;
      String entrega20D = billetes20Controller.text.isEmpty ? '0' : billetes20Controller.text;


      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(
          turno: turno,
          idturno: '2',
          idSupervisor: usuarioSession.id,
          idCajero: usuarioSession.id,
          idTipoMovimiento: '5',
          idPeaje: usuario.idPeaje,
          via: '0',
          recibe1C: '0',
          recibe5C: '0',
          recibe10C: '0',
          recibe25C: '0',
          recibe50C: '0',
          recibe2D: '0',
          recibe1D: '0',
          recibe1DB: '0',
          recibe5D: '0',
          recibe10D: '0',
          recibe20D: '0',
          entrega1C: entrega1C,
          entrega5C: entrega5C,
          entrega10C: entrega10C,
          entrega25C: entrega25C,
          entrega50C: entrega50C,
          entrega1D: entrega1D,
          entrega1DB: '0',
          entrega5D: entrega5D,
          entrega10D: entrega10D,
          entrega20D: entrega20D
      );

      // Enviar la petición
      Response response = await movimientoProvider.create(movimiento);

      print('Status Code: ${response.statusCode}'); // Depuración

      if (response.statusCode == 201) {
        Get.snackbar('Retiro Foritus exitoso', 'El retiro ha sido registrado');
        Get.offNamedUntil('/home', (route) => false, arguments: {'index': 0});
      } else if (response.statusCode == 400) {
        Get.snackbar('Error', 'Es posible que el cajero esté asignado');
      } else {
        Get.snackbar('Error', response.statusText ?? 'Error desconocido');
      }
    } catch (e) {
      print('Error: $e'); // Depuración
      Get.snackbar('Error', 'Ocurrió un error inesperado');
    }
  }





}