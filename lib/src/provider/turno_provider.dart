
import 'package:get_storage/get_storage.dart';
import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:get/get.dart';

import '../models/rol.dart';
import '../models/turno.dart';

class TurnoProvider extends GetConnect{

  String url = Environment.API_URL+"api/turnos";
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});



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
    Response response = await post(
      '$url/updateEstado',
      {
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



}