import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:asistencia_vial_app/src/provider/boveda_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../models/response_api.dart';
import '../../../models/usuario.dart';

class ModificarBovedaController extends GetxController{

  Boveda? boveda;
  Usuario usuarioSessio = Usuario.fromJson(GetStorage().read('usuario')??{});
  BovedaProvider bovedaProvider=BovedaProvider();

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
  TextEditingController ObservacionController = TextEditingController();

  ModificarBovedaController(Boveda boveda) {
    this.boveda=boveda;

    billetes20Controller.text = boveda.billete20?.toString() ?? '0';
    billetes10Controller.text = boveda.billete10?.toString() ?? '0';
    billetes5Controller.text = boveda.billete5?.toString() ?? '0';
    billetes1Controller.text = boveda.billete1?.toString() ?? '0';
    billetes2Controller.text = boveda.billete2?.toString() ?? '0';
    moneda1dController.text = boveda.moneda1?.toString() ?? '0';
    Moneda50Controller.text = boveda.moneda05?.toString() ?? '0';
    Moneda25Controller.text = boveda.moneda025?.toString() ?? '0';
    Moneda10Controller.text = boveda.moneda01?.toString() ?? '0';
    Moneda5Controller.text = boveda.moneda005?.toString() ?? '0';
    Moneda1Controller.text = boveda.moneda001?.toString() ?? '0';
  }


  void actualizarBoveda(BuildContext context, Boveda boveda) async {
    final progressDialog = ProgressDialog(context: context);

    // Mostrar el progreso
    progressDialog.show(max: 100, msg: 'Actualizando bóveda...');

    // Crear la nueva bóveda
    Boveda nuevaBoveda = Boveda(
      idpeaje: usuarioSessio.idPeaje,
      billete20: billetes20Controller.text,
      billete10: billetes10Controller.text,
      billete5: billetes5Controller.text,
      billete2: billetes2Controller.text,
      billete1: billetes1Controller.text,
      moneda1: moneda1dController.text,
      moneda05: Moneda50Controller.text,
      moneda025: Moneda25Controller.text,
      moneda01: Moneda10Controller.text,
      moneda005: Moneda5Controller.text,
      moneda001: Moneda1Controller.text,
      observacion: ObservacionController.text,
    );

    try {
      ResponseApi responseApi = await bovedaProvider.updateBoveda(nuevaBoveda);
      print('Response Api Data: ${responseApi.data}');

      // Verificar si el contexto sigue activo antes de cerrar el progreso
      if (context.mounted) {
        progressDialog.close();
      }

      // Manejar la respuesta
      if (responseApi.success == true) {
        Get.snackbar('Actualización Exitosa', 'La bóveda ha sido modificada');
        Get.offNamedUntil('/home', (route) => false);
      } else {
        Get.snackbar('Modificación Fallida', responseApi.message ?? '');
      }
    } catch (e) {
      // Manejar errores
      print('Error actualizando bóveda: $e');
      if (context.mounted) {
        progressDialog.close();
      }
      Get.snackbar('Error', 'Hubo un problema al actualizar la bóveda');
    }
  }


}