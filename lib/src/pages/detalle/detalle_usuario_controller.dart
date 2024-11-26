import 'package:asistencia_vial_app/src/pages/profile/update/admin_update.dart';
import 'package:get/get.dart';

import '../../models/usuario.dart';

class DetalleUsuarioController extends GetxController{

  Usuario? usuario;

  DetalleUsuarioController(Usuario usuario){
    this.usuario=usuario;
  }

  void goToActualizar(Usuario usuario) {
    Get.to(
          () => AdminUpdate(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }

}