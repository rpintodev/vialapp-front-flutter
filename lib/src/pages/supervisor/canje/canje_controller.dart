import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../models/usuario.dart';

class CanjeController extends GetxController{

   Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
   Usuario? usuario;
   Movimiento? movimiento;
   MovimientoProvider movimientoProvider=MovimientoProvider();
   RxBool cargando = false.obs;

   late List<Movimiento>? movimientos;



   TextEditingController billetes20Controller = TextEditingController();
   TextEditingController billetes10RecibeController = TextEditingController();
   TextEditingController billetes5RecibeController = TextEditingController();
   TextEditingController billetes1RecibeController = TextEditingController();
   TextEditingController billetes10EntregaController = TextEditingController();
   TextEditingController billetes5EntregaController = TextEditingController();
   TextEditingController billetes1EntregaController = TextEditingController();
   TextEditingController moneda50EntregaController = TextEditingController();
   TextEditingController moneda25EntregaController = TextEditingController();

   CanjeController(Usuario usuario) {
      this.usuario=usuario;
   }




   void registarCanje(BuildContext context, Usuario usuario) async {

      if (cargando.value) return; // Protección extra
      cargando.value = true;
      try {
         // Mostrar el ProgressDialog

         // Validar valores: si están vacíos, asignar '0'
         String recibe1D = billetes1RecibeController.text.isEmpty ? '0' : billetes1RecibeController.text;
         String recibe5D = billetes5RecibeController.text.isEmpty ? '0' : billetes5RecibeController.text;
         String recibe10D = billetes10RecibeController.text.isEmpty ? '0' : billetes10RecibeController.text;
         String recibe20D = billetes20Controller.text.isEmpty ? '0' : billetes20Controller.text;

         String entrega25C = moneda25EntregaController.text.isEmpty ? '0' : moneda25EntregaController.text;
         String entrega50C = moneda50EntregaController.text.isEmpty ? '0' : moneda50EntregaController.text;
         String entrega1D = billetes1EntregaController.text.isEmpty ? '0' : billetes1EntregaController.text;
         String entrega5D = billetes5EntregaController.text.isEmpty ? '0' : billetes5EntregaController.text;
         String entrega10D = billetes10EntregaController.text.isEmpty ? '0' : billetes10EntregaController.text;

         // Crear el objeto Movimiento
         Movimiento movimiento = Movimiento(
            turno: usuario.turno,
            idturno: usuario.idTurno,
            idSupervisor: usuarioSession.id,
            idCajero: usuario.id,
            idTipoMovimiento: '3',
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
            entrega25C: entrega25C,
            entrega50C: entrega50C,
            entrega1D: entrega1D,
            entrega1DB: '0',
            entrega5D: entrega5D,
            entrega10D: entrega10D,
            entrega20D: '0'
         );

         // Enviar la petición
         Response response = await movimientoProvider.create(movimiento);

         if (response.statusCode == 201) {
            Get.snackbar(
                'Transacción Exitosa',
                'El canje ha sido registrado',
                backgroundColor: Colors.green,
                colorText: Colors.white
            );
            Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
         }
         if (response.statusCode == 202) {
            Get.snackbar(
                'Transacción Offline',
                'El canje ha sido registrado exitosamente sin conexión',
                icon: Icon(Icons.cloud_off_outlined,color: Colors.white,),
                backgroundColor: Colors.orange[800],
                colorText: Colors.white
            );
            Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
         }

      } catch (e) {
         print('Error: $e'); // Depuración
         Get.snackbar('Error', 'Ocurrió un error inesperado');
      }finally{
         cargando.value = false;
      }
   }


}