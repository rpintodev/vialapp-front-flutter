import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../environment/environment.dart';
import '../models/boveda.dart';
import '../models/response_api.dart';
import '../models/usuario.dart';

class ArchivoProvider extends GetConnect {


  String url = Environment.API_URL + "api/archivos";
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario') ?? {});


  Future<Map<String, dynamic>> guardarPDF({
    required String nombreArchivo,
    required String peaje,
    required String anio,
    required String mes,
    required String fecha,
    required String turno,
    required String contenidoPDF,
    Map<String, dynamic>? metadata,
  }) async {
    print('Nombre archivo: $nombreArchivo');
    try {
      final response = await http.post(
        Uri.parse('$url/reporteLiquidacion'),
        headers: {'Content-Type': 'application/json','Authorization': usuario.sessionToken ?? ''},
        body: jsonEncode({
          'nombreArchivo': nombreArchivo,
          'peaje': peaje,
          'anio':anio,
          'mes':mes,
          'fecha':fecha,
          'turno':turno,
          'contenidoPDF': contenidoPDF,
          'metadata': metadata ?? {},
        }),
      );

      if (response.statusCode == 200) {
        return {
          'exito': true,
          'mensaje': 'PDF guardado exitosamente',
          'datos': jsonDecode(response.body)
        };
      } else {
        return {
          'exito': false,
          'mensaje': 'Error al guardar PDF: ${response.statusCode}',
          'error': response.body
        };
      }
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'Error de conexión',
        'error': e.toString()
      };
    }
  }


}