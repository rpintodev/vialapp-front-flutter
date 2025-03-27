import 'package:asistencia_vial_app/src/models/turno.dart';
import 'package:asistencia_vial_app/src/pages/profile/update/admin_update.dart';
import 'package:asistencia_vial_app/src/provider/turno_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../models/usuario.dart';

class DetalleUsuarioController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});
  TurnoProvider turnoProvider=TurnoProvider();



  Usuario? usuario;

  DetalleUsuarioController(Usuario usuario) {
    this.usuario=usuario;
  }


  void asignarTuno(BuildContext context, Usuario usuario) async{
    ProgressDialog progressDialog=ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Asigando Turno..');

    Turno turnos=Turno(
      idSupervisor: usuarioSession.id,
      idCajero: usuario?.id,
      estado: '2',
      sessionToken: usuarioSession.sessionToken,

    );

    Response response = await turnoProvider.create(turnos);
    print('Response Api Data: ${response.body}');
    print('Turno: ${turnos.idCajero}');
    progressDialog.close();
    if(response.statusCode ==201){
      Get.snackbar('Asignacion Existosa', 'El usuario ha sido asignado');
      Get.offNamedUntil('/home', (route)=>false);

    }else{
      Get.snackbar('ERROR ', response.statusText??'');

    }


  }


  void goToActualizar(Usuario usuario) {
    Get.to(
          () => AdminUpdate(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

}