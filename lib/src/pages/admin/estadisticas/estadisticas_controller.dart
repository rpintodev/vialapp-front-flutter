import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/usuario.dart';

class EstadisticasController extends GetxController{
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});


  void signOut(){
    GetStorage().remove('usuario');
    Get.offNamedUntil('/',(route)=>false);

  }

  void gotoRegisterPage(){
    Get.toNamed('/register');
  }
}