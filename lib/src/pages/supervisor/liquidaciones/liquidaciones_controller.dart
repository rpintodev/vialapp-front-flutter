import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/models/response_api.dart';
import 'package:asistencia_vial_app/src/provider/turno_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';
import '../../../provider/movimiento_provider.dart';
import '../../editar_transaccion/editar_transaccion.dart';
import '../retiros_parciales/retiro_parcial.dart';

class LiquidacionesController extends GetxController{
  Socket socket = io('${Environment.API_URL}',<String,dynamic>{
    'transports':['websocket'],
    'autoConnect':false
  });

  RxBool cargando = false.obs;


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

  MovimientoProvider movimientoProvider=MovimientoProvider();
  TurnoProvider turnoProvider=TurnoProvider();

  Usuario usuarioSession = Usuario.fromJson(GetStorage().read('usuario')??{});

  Usuario? usuario;
  List<Movimiento>? movimientos;



  LiquidacionesController(Usuario usuario,List<Movimiento> movimientos) {
    this.usuario=usuario;
    this.movimientos=movimientos;
    connectAndListen();
  }

  void connectAndListen(){
    socket.connect();
    socket.onConnect((data)=>{
      print('Este dispositivo se conecto a SOCKET')
    });
  }


  void goToEditTransaccion(Movimiento movimiento) {
    Get.off(
          () => EditarTransaccionPage(movimiento: movimiento), // Página a la que navegas
    );

  }

  void goToRetiroParcial(Usuario usuario) {

    Get.to(
          () => RetiroParcialPage(usuario: usuario), // Página a la que navegas
      arguments: usuario, // Envía el objeto Usuario como argumento
    );
  }




  void registarLiquidacion(BuildContext context, Usuario usuario, List<Movimiento> movimientos) async {

    if (cargando.value) return; // Protección extra
    cargando.value = true;
    try {

      //final liquidacion = movimientos.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
      final liquidacion = movimientos.firstWhere(
              (m) => m.idTipoMovimiento == '4',
          orElse: () => Movimiento(partetrabajo: '0') // Asignar '0' si no hay liquidación
      );

      // Validar valores: si están vacíos, asignar '0'
      String recibe1C = Moneda1Controller.text.isEmpty ? '0' : Moneda1Controller.text;
      String recibe5C = Moneda5Controller.text.isEmpty ? '0' : Moneda5Controller.text;
      String recibe10C = Moneda10Controller.text.isEmpty ? '0' : Moneda10Controller.text;
      String recibe25C = Moneda25Controller.text.isEmpty ? '0' : Moneda25Controller.text;
      String recibe50C= Moneda50Controller.text.isEmpty ? '0' : Moneda50Controller.text;
      String recibe1D = moneda1dController.text.isEmpty ? '0' : moneda1dController.text;
      String recibe1DB = billetes1Controller.text.isEmpty ? '0' : billetes1Controller.text;
      String recibe2D = billetes2Controller.text.isEmpty ? '0' : billetes2Controller.text;
      String recibe5D = billetes5Controller.text.isEmpty ? '0' : billetes5Controller.text;
      String recibe10D = billetes10Controller.text.isEmpty ? '0' : billetes10Controller.text;
      String recibe20D = billetes20Controller.text.isEmpty ? '0' : billetes20Controller.text;


      // Crear el objeto Movimiento
      Movimiento movimiento = Movimiento(

          id: liquidacion.id,
          turno: usuario.turno,
          idturno: usuario.idTurno,
          idSupervisor: usuarioSession.id,
          idCajero: usuario.id,
          idTipoMovimiento: '4',
          idPeaje: usuarioSession.idPeaje,
          via: usuario.via,
          partetrabajo: liquidacion.partetrabajo,
          recibe1C: recibe1C,
          recibe5C: recibe5C,
          recibe10C: recibe10C,
          recibe25C: recibe25C,
          recibe50C: recibe50C,
          recibe2D: recibe2D,
          recibe1D: recibe1D,
          recibe1DB: recibe1DB,
          recibe5D: recibe5D,
          recibe10D: recibe10D,
          recibe20D: recibe20D,
          entrega1C: '0',
          entrega5C: '0',
          entrega10C: '0',
          entrega25C: '0',
          entrega50C: '0',
          entrega1D: '0',
          entrega1DB: '0',
          entrega5D: '0',
          entrega10D: '0',
          entrega20D: '0',
          anulaciones: '0',
          valoranulaciones: '0',
          simulaciones: '0',
          valorsimulaciones: '0',
          sobrante: '0'
      );


      if(liquidacion.partetrabajo=='0'){ //SI NO SE AGREGÓ EL PARTE DE TRABAJO
        Response response = await movimientoProvider.create(movimiento);
        Response response2 = await turnoProvider.updateEstado(usuario.idTurno??'');

        if(response.statusCode == 201){
          socket.emit('actualizar_turno', {
            'id_turno': usuario.idTurno
          });
          Get.snackbar('Liquidación Existosa', 'La apertura ha sido retirada');
          Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
        }

      }else{//SE AGREGÓ EL PARTE DE TRABAJO

        ResponseApi responseApi = await movimientoProvider.updateLiquidacionCompleta(movimiento);
        Response response2 = await turnoProvider.updateEstado(usuario.idTurno??'');

        if(responseApi.success==true){
          socket.emit('actualizar_turno', {
            'id_turno': usuario.idTurno
          });
          Get.snackbar('Liquidación Existosa: ${liquidacion.id}', 'La apertura ha sido retirada');
          Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2});
        }else{
          Get.snackbar('ERROR ', responseApi.message??'');

        }
      }

    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error inesperado');
    }finally{
      cargando.value = false;
    }
  }

  @override
  void onClose(){
    print('SE CERRO LA LIQUIDACION');
    socket.disconnect();
  }
}