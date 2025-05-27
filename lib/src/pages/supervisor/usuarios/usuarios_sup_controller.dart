import 'package:asistencia_vial_app/src/pages/detalle/detalle_usuario.dart';
import 'package:asistencia_vial_app/src/provider/rol_provider.dart';
import 'package:asistencia_vial_app/src/provider/turno_provider.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../models/rol.dart';
import '../../../models/turno.dart';
import '../../../models/usuario.dart';
import '../../profile/update/admin_update.dart';

class UsuariosSupController extends GetxController{

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  UsuarioProvider usuarioProvider = UsuarioProvider();
  TurnoProvider turnoProvider = TurnoProvider();

  var currentTabIndex = 1.obs;

  var usuariosGrupoActual = <Usuario>[].obs; // Lista de usuarios del grupo actual

  Future<void> loadUsuariosGrupoActual(int groupIndex,String idPeaje) async {
    var usuarios =  await usuarioProvider.findByGrupo(groupIndex.toString(),idPeaje);
    usuariosGrupoActual.value = usuarios;
  }

  void updateTabIndex(int index) {
    currentTabIndex.value = index+1;
  }

  Future<List<Usuario>> getUsuariosGrupo(String idGrupo,String idPeaje) async{
    return await usuarioProvider.findByGrupo(idGrupo,idPeaje);
  }



  void openBottomSheet(BuildContext context, Usuario usuario){
    showBarModalBottomSheet(
        context: context,
        builder: (context)=>DetalleUsuario(usuario: usuario)
    );
  }

  void asignarTurnoLote(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Asignando Turnos...');



    // Preparamos la lista de turnos a asignar en lote
    List<Turno> turnosLote = usuariosGrupoActual.map((usuario) {
      return Turno(
        idSupervisor: usuarioSession.id,
        idCajero: usuario.id,
        estado: '2', // Estado del turno, por ejemplo: '2' para asignado
        sessionToken: usuarioSession.sessionToken,
      );
    }).toList();

    // Realizamos la llamada a la API para crear los turnos en lote
    Response response = await turnoProvider.createBatch(turnosLote);

    progressDialog.close();

    if (response.statusCode == 201) {
      Get.snackbar('Asignación Exitosa', 'Los usuarios han sido asignados al turno');
      Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
    } if(response.statusCode ==400){
    Get.snackbar('ERROR AL ASIGNAR ', 'Es posible que uno de los cajeros del grupo ya este en turno');
    }else{

    }

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
      Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});

    }if(response.statusCode ==400){
      Get.snackbar('ERROR AL ASIGNAR ', 'Es posible que el cajero este asignado');
    }else{

    }


  }

  void goToActualizar(Usuario usuario) {
    Get.to(
          () => AdminUpdate(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }


  void gotoRegisterPage(){
    Get.toNamed('/register');
  }
}
