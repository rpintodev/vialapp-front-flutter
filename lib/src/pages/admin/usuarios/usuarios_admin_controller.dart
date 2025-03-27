import 'package:asistencia_vial_app/src/provider/rol_provider.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../models/rol.dart';
import '../../../models/usuario.dart';
import '../../detalle/detalle_usuario.dart';
import '../../profile/update/admin_update.dart';

class UsuariosAdminController extends GetxController{

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});

  UsuarioProvider usuarioProvider = UsuarioProvider();


  RolProvider rolProvider = RolProvider();
  List<Rol> roles= <Rol>[].obs;

  UsuariosAdminController(){
  getRoles();

  }


  Future<List<Usuario>> getUsuarios(String idRol) async{
    return await usuarioProvider.findByRol(idRol);
  }



  void getRoles() async{
    var result = await rolProvider.getAll();
    roles.clear();
    roles.addAll(result);
    update();
  }


  void openBottomSheet(BuildContext context, Usuario usuario){
    showBarModalBottomSheet(
        context: context,
        builder: (context)=>DetalleUsuario(usuario: usuario)
    );
  }


  void goToActualizar(Usuario usuario) {
    Get.to(
          () => AdminUpdate(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

  Future<void> deleteUsuario(String idUsuario) async {
    try {
      var response = await usuarioProvider.eliminar(idUsuario);
      if (response.isOk) {
        Get.snackbar('Eliminado', 'El usuario ha sido eliminado del sistema');
        getRoles();
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el usuario:${idUsuario}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al eliminar el turno: $e');
    }
  }




  void gotoRegisterPage(){
    Get.toNamed('/register');
  }
}