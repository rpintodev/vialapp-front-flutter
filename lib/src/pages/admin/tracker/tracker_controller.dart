import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TrackerController extends GetxController{

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});


  TrackerController(){
    print('Usuario de session: ${usuario.toJson()}');

  }


  void signOut(){
    GetStorage().remove('usuario');
    Get.offNamedUntil('/',(route)=>false);

  }

}