
import 'package:asistencia_vial_app/src/provider/provider-offline/turno_provider_offline.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../helper/connection_helper.dart';
import '../models/rol.dart';
import '../models/turno.dart';

class TurnoProvider extends GetConnect{

  String url = Environment.API_URL+"api/turnos";
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});
  TurnoProviderOffline turnoOffline = TurnoProviderOffline();


  Future<Response> create(Turno turno) async{
    Response response = await post(
        '$url/create',
        turno.toJson(),
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken??''
        }

    );
    return response;
  }

  Future<List<Turno>> getAll(String idTurno) async {

    Response response = await post(
        '$url/getAll',
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

    List<Turno> turnos= Turno.fromJsonList(response.body);
    return turnos;

  }

  Future<Response> eliminar(String idCajero) async {
    Response response = await post(
      '$url/delete',
      {
        'IdCajero': idCajero
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes permiso para realizar esta acción');
    }


    return response;
  }

  Future<Response> enviarTurno(String idCajero) async {
    Response response = await post(
      '$url/enviarTurno',
      {
        'IdCajero': idCajero
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes permiso para realizar esta acción');
    }

    return response;
  }

  Future<Response> enviarBoveda(String idCajero,String idTurno) async {
    Response response = await post(
      '$url/enviarBoveda',
      {
        'IdCajero': idCajero,
        'IdTurno': idTurno

      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes permiso para realizar esta acción');
    }
    print(idCajero);

    return response;
  }


  Future<Response> createBatch(List<Turno> turnos) async {
    List<Map<String, dynamic>> turnosJson = turnos.map((t) => t.toJson()).toList();

    Response response = await post(
      '$url/createBatch',
      turnosJson,
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    return response;
  }

  Future<Response> updateVia(String via,String idTurno) async {
    Response response = await post(
      '$url/updateVia',
      {
        'Via': via,
        'IdTurno': idTurno
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': usuario.sessionToken ?? ''
      },
    );

    if (response.statusCode == 401) {
      Get.snackbar('Petición Denegada', 'No tienes permiso para realizar esta acción');
    }

    return response;
  }

  Future<Response> updateEstado(String idTurno) async {

    Response response;

    if(await isConnectedToServer() ){
      response = await post(
        '$url/updateEstado',
        {
          'IdTurno': idTurno
        },
        headers: {
          'Content-type': 'application/json',
          'Authorization': usuario.sessionToken ?? ''
        },
      );
    }else{
      await turnoOffline.saveTurno(Turno(id:idTurno,idSupervisor: '0',idCajero: '0',via: '0'));
      response= Response(
        statusCode: 202,
        body: {'message': 'Transacción guardada offline'},
        statusText: 'Guardado en cache',
        request: Request(
            url: Uri.parse('$url/updateEstado'),
            method: 'POST',
            headers: {
              'Content-type': 'application/json',
              'Authorization': usuario.sessionToken??''
            }),
      );
    }
    return response;

  }

  Future<void> sincronizarTurnosPendientes() async {
    final box = await Hive.openBox<Turno>('turno');

    final keys = box.keys.toList();

    for (var key in keys) {
      Turno? turno = box.get(key);

      try {
        // Intenta enviar al servidor
        Response response = await updateEstado(key.toString());

        if (response.statusCode == 200) {
          await box.delete(key); // Eliminar si fue exitoso
          print('Transacción enviada y eliminada: $key');
        } else {
          print('No se pudo sincronizar turnos: $key');
        }
      } catch (e) {
        print('Error al sincronizar $key: $e');
      }
    }
  }




}