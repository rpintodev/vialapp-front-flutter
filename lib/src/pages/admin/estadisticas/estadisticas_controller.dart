import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/usuario.dart';

class EstadisticasController extends GetxController{
  Usuario usuario = Usuario.fromJson(GetStorage().read('usuario')??{});

  // 📅 Fecha seleccionada
  var selectedDate = DateTime.now().obs;

  // 📊 Datos dinámicos para el gráfico
  var datosGrafico = <double>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarDatos(); // Cargar datos al iniciar
  }

  /// 🔄 **Actualizar la fecha y recargar datos**
  void updateDate(DateTime nuevaFecha) {
    selectedDate.value = nuevaFecha;
    cargarDatos();
  }

  /// 📊 **Simulación de datos para el gráfico**
  void cargarDatos() {
    datosGrafico.clear();
    Random random = Random();

    // **Asegurar que siempre haya 24 datos (una por cada hora)**
    for (int i = 0; i < 50; i++) {
      double valor = random.nextInt(6000).toDouble();
      datosGrafico.add(valor);
    }
    update(); // Notificar actualización
  }

  /// 📌 **Obtener los puntos del gráfico**
  List<FlSpot> getSpots() {
    // ⚠️ Verificar si la lista está vacía para evitar errores
    if (datosGrafico.isEmpty) {
      return [FlSpot(0, 0)];
    }

    return List.generate(24, (index) {
      return FlSpot(index.toDouble(), datosGrafico[index]);
    });
  }
}