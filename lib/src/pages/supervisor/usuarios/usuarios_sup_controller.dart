import 'package:asistencia_vial_app/src/pages/detalle/detalle_usuario.dart';
import 'package:asistencia_vial_app/src/provider/rol_provider.dart';
import 'package:asistencia_vial_app/src/provider/usuario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../models/rol.dart';
import '../../../models/usuario.dart';

class UsuariosSupController extends GetxController{

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});

  UsuarioProvider usuarioProvider = UsuarioProvider();


  RolProvider rolProvider = RolProvider();
  List<Rol> roles= <Rol>[].obs;



  UsuariosAdminController(){
  getRoles();

  }



  Future<List<Usuario>> getUsuariosGrupo(String idGrupo) async{
    return await usuarioProvider.findByGrupo(idGrupo);
  }

  void getRoles() async{
    var result = await rolProvider.getAll();
    roles.clear();
    roles.addAll(result);
  }


  void openBottomSheet(BuildContext context, Usuario usuario){
    showBarModalBottomSheet(
        context: context,
        builder: (context)=>DetalleUsuario(usuario: usuario)
    );
  }


  void gotoRegisterPage(){
    Get.toNamed('/register');
  }
}