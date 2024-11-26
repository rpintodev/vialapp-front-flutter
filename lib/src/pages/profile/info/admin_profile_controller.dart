import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/usuario.dart';

class AdminProfileController extends GetxController{

  var usuario = Usuario.fromJson(GetStorage().read('usuario')??{}).obs;

  void signOut(){
    GetStorage().remove('usuario');
    Get.offNamedUntil('/',(route)=>false);

  }

  void gotoUpdate(){
    Get.toNamed('/profile/update');
  }



}