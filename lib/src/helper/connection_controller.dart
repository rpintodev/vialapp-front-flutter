import 'dart:async';
import 'package:asistencia_vial_app/src/provider/turno_provider.dart';
import 'package:get/get.dart';

import '../provider/movimiento_provider.dart';
import 'connection_helper.dart';

class ConnectionController extends GetxController {
  var isOffline = false.obs;
  Timer? _timer;
  MovimientoProvider movimientoProvider=MovimientoProvider();
  TurnoProvider turnoProvider=TurnoProvider();

  @override
  void onInit() {
    super.onInit();
    checkConnection(); // Verifica una vez al iniciar

    // Verifica cada 10 segundos (puedes ajustar el intervalo)
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      checkConnection();
    });
  }

  Future<void> checkConnection() async {
    final connected = await isConnectedToServer();
    isOffline.value = !connected;
    connected?movimientoProvider.sincronizarTransaccionesPendientes():'';
    connected?movimientoProvider.sincronizarActualizacionDeTransaccionesPendientes():'';
    connected?turnoProvider.sincronizarTurnosPendientes():'';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
