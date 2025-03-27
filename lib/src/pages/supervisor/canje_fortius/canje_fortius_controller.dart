import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../models/usuario.dart';

class CanjeFortiusController extends GetxController{

   Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
   Usuario? usuario;
   Movimiento? movimiento;
   MovimientoProvider movimientoProvider=MovimientoProvider();




   TextEditingController billetes5RecibeController = TextEditingController();
   TextEditingController billetes1RecibeController = TextEditingController();
   TextEditingController billetes10EntregaController = TextEditingController();
   TextEditingController billetes20EntregaController = TextEditingController();

   CanjeFortiusController(Usuario usuario) {
      this.usuario=usuario;
      print(usuario.idTurno);
   }




   void registarCanje(BuildContext context, Usuario usuario) async {

      try {
         // Mostrar el ProgressDialog

         // Validar valores: si están vacíos, asignar '0'
         String recibe1D = billetes1RecibeController.text.isEmpty ? '0' : billetes1RecibeController.text;
         String recibe5D = billetes5RecibeController.text.isEmpty ? '0' : billetes5RecibeController.text;



         String entrega10D = billetes10EntregaController.text.isEmpty ? '0' : billetes10EntregaController.text;
         String entrega20D = billetes20EntregaController.text.isEmpty ? '0' : billetes20EntregaController.text;

         // Crear el objeto Movimiento
         Movimiento movimiento = Movimiento(
             turno: '2',
             idturno: '2',
            idSupervisor: usuarioSession.id,
            idCajero: usuarioSession.id,
            idTipoMovimiento: '5',
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
            recibe10D: '0',
            recibe20D: '0',
            entrega1C: '0',
            entrega5C: '0',
            entrega10C: '0',
            entrega25C: '0',
            entrega50C: '0',
            entrega1D: '0',
            entrega1DB: '0',
            entrega5D: '0',
            entrega10D: entrega10D,
            entrega20D: entrega20D
         );

         // Enviar la petición
         Response response = await movimientoProvider.create(movimiento);

         print('Status Code: ${response.statusCode}'); // Depuración

         if (response.statusCode == 201) {
            Get.snackbar('Canje Exitosa', 'El canje ha sido registrado');
            Get.offNamedUntil('/home', (route) => false, arguments: {'index': 1});
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