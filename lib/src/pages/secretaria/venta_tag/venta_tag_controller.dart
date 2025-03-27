import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';
import '../../../provider/turno_provider.dart';

class VentaTagController extends GetxController{

  TextEditingController billetes20Controller = TextEditingController();
  TextEditingController billetes10Controller = TextEditingController();
  TextEditingController billetes5Controller = TextEditingController();
  TextEditingController billetes2Controller = TextEditingController();
  TextEditingController billetes1Controller = TextEditingController();
  TextEditingController moneda1dController = TextEditingController();
  TextEditingController Moneda50Controller = TextEditingController();
  TextEditingController Moneda25Controller = TextEditingController();
  TextEditingController Moneda10Controller = TextEditingController();
  TextEditingController Moneda5Controller = TextEditingController();
  TextEditingController Moneda1Controller = TextEditingController();

  MovimientoProvider movimientoProvider=MovimientoProvider();
  TurnoProvider turnoProvider=TurnoProvider();

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  Usuario? usuario;
  List<Movimiento>? movimientos;

  void registarLiquidacion(BuildContext context, Usuario usuario) async {

    try {

      // Validar valores: si están vacíos, asignar '0'
      String recibe1C = Moneda1Controller.text.isEmpty ? '0' : Moneda1Controller.text;
      String recibe5C = Moneda5Controller.text.isEmpty ? '0' : Moneda5Controller.text;
      String recibe10C = Moneda10Controller.text.isEmpty ? '0' : Moneda10Controller.text;
      String recibe25C = Moneda25Controller.text.isEmpty ? '0' : Moneda25Controller.text;
      String recibe50C= Moneda50Controller.text.isEmpty ? '0' : Moneda50Controller.text;
      String recibe1D = moneda1dController.text.isEmpty ? '0' : moneda1dController.text;
      String recibe1DB = billetes1Controller.text.isEmpty ? '0' : billetes1Controller.text;
      String recibe2D = billetes2Controller.text.isEmpty ? '0' : billetes2Controller.text;
      String recibe5D = billetes5Controller.text.isEmpty ? '0' : billetes5Controller.text;
      String recibe10D = billetes10Controller.text.isEmpty ? '0' : billetes10Controller.text;
      String recibe20D = billetes20Controller.text.isEmpty ? '0' : billetes20Controller.text;



      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(
          turno: '2',
          idturno: '2',
          idSupervisor: usuarioSession.id,
          idCajero: usuarioSession.id,
          idTipoMovimiento: '7',
          idPeaje: usuarioSession.idPeaje,
          via: usuario.via,
          recibe1C: recibe1C,
          recibe5C: recibe5C,
          recibe10C: recibe10C,
          recibe25C: recibe25C,
          recibe50C: recibe50C,
          recibe2D: recibe2D,
          recibe1D: recibe1D,
          recibe1DB: recibe1DB,
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
      print('Status Code: ${response.statusCode}'); // Depuración

      if (response.statusCode == 201) {
        Get.snackbar('Liquidación Exitosa', 'La liquidación ha sido registrado');
        Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
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