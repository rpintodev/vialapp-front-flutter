import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';

class AperturaController extends GetxController{

  MovimientoProvider movimientoProvider=MovimientoProvider();
  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  Usuario? usuario;


  TextEditingController billetes10Controller = TextEditingController();
  TextEditingController billetes5Controller = TextEditingController();
  TextEditingController billetes1Controller = TextEditingController();
  TextEditingController Moneda50Controller = TextEditingController();
  TextEditingController Moneda25Controller = TextEditingController();
  TextEditingController Moneda10Controller = TextEditingController();
  TextEditingController Moneda5Controller = TextEditingController();
  TextEditingController Moneda1Controller = TextEditingController();



  AperturaController(Usuario usuario) {
    this.usuario=usuario;
  }


  void registarApertura(BuildContext context, Usuario usuario) async {

    try {


      String recibe10D = billetes10Controller.text.isEmpty ? '0' : billetes10Controller.text;
      String recibe5D = billetes5Controller.text.isEmpty ? '0' : billetes5Controller.text;
      String recibe1D = billetes1Controller.text.isEmpty ? '0' : billetes1Controller.text;
      String recibe50C = Moneda50Controller.text.isEmpty ? '0' : Moneda50Controller.text;
      String recibe25C = Moneda25Controller.text.isEmpty ? '0' : Moneda25Controller.text;
      String recibe10C = Moneda10Controller.text.isEmpty ? '0' : Moneda10Controller.text;
      String recibe5C = Moneda5Controller.text.isEmpty ? '0' : Moneda5Controller.text;
      String recibe1C = Moneda1Controller.text.isEmpty ? '0' : Moneda1Controller.text;



      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(
          turno: usuario.turno,
          idSupervisor: usuarioSession.id,
          idCajero: usuario.id,
          idTipoMovimiento: '1',
          idPeaje: usuarioSession.idPeaje,
          via: usuario.via,
          idturno: usuario.idTurno,
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
          entrega1C: recibe1C,
          entrega5C: recibe5C,
          entrega10C: recibe10C,
          entrega25C: recibe25C,
          entrega50C: recibe50C,
          entrega1D: recibe1D,
          entrega1DB: '0',
          entrega5D: recibe5D,
          entrega10D: recibe10D,
          entrega20D: '0'
      );

      // Enviar la petición
      Response response = await movimientoProvider.create(movimiento);

      print('Status Code: ${response.statusCode}'); // Depuración

      if (response.statusCode == 201) {
        Get.snackbar('Aperturación Exitosa', 'La apartura ha sido registrado');
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