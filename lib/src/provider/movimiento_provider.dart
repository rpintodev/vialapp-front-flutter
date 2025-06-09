import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/provider/provider-offline/movimiento_provider_offline.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

import '../environment/environment.dart';
import '../helper/connection_helper.dart';
import '../models/boveda.dart';
import '../models/response_api.dart';
import '../models/usuario.dart';


class MovimientoProvider extends GetConnect{

  String url = Environment.API_URL+"api/movimientos";
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});
  MovimientoProviderOffline movimientoOffline=MovimientoProviderOffline();

  Future<Response> create(Movimiento movimiento) async{
  Response response;
    if(await isConnectedToServer()){
       response = await post(
          '$url/create',
          movimiento.toJsonSinId(),
          headers: {
            'Content-type': 'application/json',
            'Authorization': usuario.sessionToken??''
          }
      );
    }else{
      await movimientoOffline.saveTransaccion(movimiento);
      // ⚠️ Simular un Response exitoso (status 202)
        response= Response(
        statusCode: 202,
        body: {'message': 'Transacción guardada offline'},
        statusText: 'Guardado en cache',
        request: Request(
            url: Uri.parse('$url/create'),
            method: 'POST',
            headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }),
      );
    }


    return response;
  }


  Future<Movimiento?> getApertura(String idTurno) async {
    Response response = await post(
      '$url/getApertura',
      {
        'IdTurno': idTurno
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes acceso a esta información');
      return null;
    }

    if (response.statusCode == 200) {
      // Si la respuesta es un único objeto JSON
      if (response.body is Map<String, dynamic>) {
        return Movimiento.fromJson(response.body);
      }
      // Si la respuesta es una lista, toma el primer objeto
      else if (response.body is List && response.body.isNotEmpty) {
        return Movimiento.fromJson(response.body.first);
      }
    }

    return null;
  }

  Future<Movimiento?> getFaltante(String idTurno) async {
    Response response = await post(
      '$url/getFaltante',
      {
        'IdTurno': idTurno
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes acceso a esta información');
      return null;
    }

    if (response.statusCode == 200) {
      // Si la respuesta es un único objeto JSON
      if (response.body is Map<String, dynamic>) {
        return Movimiento.fromJson(response.body);
      }
      // Si la respuesta es una lista, toma el primer objeto
      else if (response.body is List && response.body.isNotEmpty) {
        return Movimiento.fromJson(response.body.first);
      }
    }

    return null;
  }




  Future<Response> update(Movimiento movimiento) async{

    Response response = await post(
        '$url/updateApertura',
        movimiento.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );


    return response;
  }


  Future<ResponseApi> updateLiquidacion(Movimiento movimiento) async{

    Response response = await post(
        '$url/updateLiquidacion',
        movimiento.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }

    if(response.statusCode==401){
      Get.snackbar('Error', 'No se esta autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateEstadoMovimiento(Movimiento movimiento) async{

    Response response = await post(
        '$url/updateEstadoMovimiento',
        movimiento.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }

    if(response.statusCode==401){
      Get.snackbar('Error', 'No se esta autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateLiquidacionCompleta(Movimiento movimiento) async{

    Response response = await post(
        '$url/updateLiquidacionCompleta',
        movimiento.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );

    if(response.body==null){
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }

    if(response.statusCode==401){
      Get.snackbar('Error', 'No se esta autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }


  Future<List<Movimiento>> getTipoMovimiento() async {

    Response response = await get(
        '$url/getTipoMovimiento',
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }

  Future<List<Movimiento>> findByTipoMovimiento(String idTipoMovimiento, String idPeaje) async {

    Response response = await post(
        '$url/findByTipoMovimiento',
        {
          'id_tipomovimiento': idTipoMovimiento,
          'id_peaje': idPeaje

        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }

  Future<List<Movimiento>> findByDateTipoMovimiento(String fechainicio,String fechafin,String idTipoMovimiento, String idPeaje) async {

    Response response = await post(
        '$url/findByDateTipoMovimiento',
        {
          'fecha_inicio': fechainicio,
          'fecha_fin': fechafin,
          'id_tipomovimiento': idTipoMovimiento,
          'id_peaje': idPeaje

        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }

  Future<List<Movimiento>> getMovimientoByTurno(String idTurno) async {

    Response response = await post(
        '$url/findByTurno',
        {
          'IdTurno': idTurno

        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }


  Future<List<Movimiento>> getRetirosParciales(String idTurno) async {

    Response response = await post(
        '$url/getRetirosParciales',
        {
          'IdTurno': idTurno

        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }

  Future<List<Movimiento>> getRetirosParcialesByDate(String idpeaje) async {

    Response response = await post(
        '$url/getRetirosParcialesByDate',
        {
          'id_peaje': idpeaje,


        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }
  Future<List<Movimiento>> getRetirosParcialesByDateActual(String idpeaje) async {

    Response response = await post(
        '$url/getRetirosParcialesByDateActual',
        {
          'id_peaje': idpeaje,


        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }


 Future<List<Movimiento>> getAperturasByDate(String idpeaje) async {

    Response response = await post(
        '$url/getAperturasByDate',
        {
          'id_peaje': idpeaje,


        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }
 Future<List<Movimiento>> getLiquidacionesByDate(String idpeaje) async {

    Response response = await post(
        '$url/getLiquidacionesByDate',
        {
          'id_peaje': idpeaje,


        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }
 Future<List<Movimiento>> getFortiusByDate(String idpeaje) async {

    Response response = await post(
        '$url/getFortiusByDate',
        {
          'id_peaje': idpeaje,


        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }

  Future<List<Movimiento>> getFortiusByDateActual(String idpeaje) async {

    Response response = await post(
        '$url/getFortiusByDateActual',
        {
          'id_peaje': idpeaje,


        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }


  Future<List<Movimiento>> getMovimientosReporteRetiros(String idPeaje) async {

    Response response = await post(
        '$url/getMovimientosReporteRetiros',
        {
          'id_peaje': idPeaje

        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }
    );

    if (response.statusCode == 401) {
      Get.snackbar('Peticion Denegada', 'No tienes acceso a esta información');
      return [];
    }

    List<Movimiento> movimientos= Movimiento.fromJsonList(response.body);
    return movimientos;

  }

  Future<void> sincronizarTransaccionesPendientes() async {
    final box = await Hive.openBox<Movimiento>('transacciones');

    final keys = box.keys.toList();

    for (var key in keys) {
      Movimiento? movimiento = box.get(key);

      try {
        // Intenta enviar al servidor
        Response response = await create(movimiento!);

        if (response.statusCode == 201) {
          await box.delete(key); // Eliminar si fue exitoso
          print('Transacción enviada y eliminada: $key');
        } else {
          print('No se pudo sincronizar: $key, status: ${movimiento.id}');
        }
      } catch (e) {
        print('Error al sincronizar $key: $e');
      }
    }
  }



}