import 'package:asistencia_vial_app/src/environment/environment.dart';
import 'package:asistencia_vial_app/src/provider/movimiento_provider.dart';
import 'package:http/http.dart' as http;

Future<bool> isConnectedToServer() async {
  // o tu endpoint de salud

  try {
    final response = await http
        .get(Uri.parse('${Environment.API_URL}test'))
        .timeout(const Duration(seconds: 3));

    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}
