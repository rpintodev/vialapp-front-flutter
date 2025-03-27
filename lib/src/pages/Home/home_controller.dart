import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class HomeSupController extends GetxController{

  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});



  var indexTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Lee los argumentos pasados al Home
    var args = Get.arguments;
    if (args != null && args['index'] != null) {
      indexTab.value = args['index'];
    }
  }


  void chanceTab(int index){
    indexTab.value=index;
    print('Response Api Data: ${usuario.roles?.first.id}');

  }




}