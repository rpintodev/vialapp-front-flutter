import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/pages/secretaria/transacciones/transacciones_secre_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/usuario.dart';

class TransaccionesSecre extends StatelessWidget {
  TransaccionesSecrecontroller transaccionesController = Get.put(TransaccionesSecrecontroller());
  final Usuario usuario = Usuario.fromJson(GetStorage().read('usuario') ?? {});

  @override
  Widget build(BuildContext context) {
    transaccionesController.getBoveda(usuario.idPeaje??'0');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Row(
                  children: [
                    // Campo de Fecha Inicio
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          String? fechaSeleccionada = await _selectDate(context, true);
                          if (fechaSeleccionada != null) {
                            transaccionesController.fechaInicio.value = fechaSeleccionada;
                            _loadMovimientos();
                          }
                        },
                        child: _dateField(
                          label: 'Fecha Inicio',
                          value: transaccionesController.fechaInicio.value,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    // Campo de Fecha Fin
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          String? fechaSeleccionada = await _selectDate(context, false);
                          if (fechaSeleccionada != null) {
                            transaccionesController.fechaFin.value = fechaSeleccionada;
                            _loadMovimientos();
                          }
                        },
                        child: _dateField(
                          label: 'Fecha Fin',
                          value: transaccionesController.fechaFin.value,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Botón de Búsqueda
                    IconButton(
                      icon: Icon(Icons.cleaning_services, color: Color(0xFF368983), size: 30),
                      onPressed: _clearFilters, // Limpia los filtros
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => _buildTabContent(7)), // Solo carga el tipo movimiento con id=7
    );
  }

  /// Carga los movimientos del tipo especificado
  Widget _buildTabContent(int idTipoMovimiento) {
    return FutureBuilder(
      future: transaccionesController.getMovimientos(
        transaccionesController.fechaInicio.value,
        transaccionesController.fechaFin.value,
        idTipoMovimiento.toString(),
        transaccionesController.usuarioSession.idPeaje ?? '1',
      ),
      builder: (context, AsyncSnapshot<List<Movimiento>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              return _transactionCard(context, snapshot.data![index]);
            },
          );
        }

        return Center(child: Text("No hay datos disponibles"));
      },
    );
  }

  void _loadMovimientos() {
    if (transaccionesController.fechaInicio.isNotEmpty &&
        transaccionesController.fechaFin.isNotEmpty) {
      transaccionesController.getMovimientos(
        transaccionesController.fechaInicio.value,
        transaccionesController.fechaFin.value,
        '7', // Solo para el tipo de movimiento con id=7
        transaccionesController.usuarioSession.idPeaje ?? '1',
      );
    }
  }

  /// Limpia los filtros y recarga los datos
  void _clearFilters() {
    transaccionesController.fechaInicio.value = '';
    transaccionesController.fechaFin.value = '';
    _loadMovimientos(); // Reinicia la búsqueda sin filtros
  }

  /// Widget para el campo de fecha
  Widget _dateField({required String label, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 20, color: Color(0xFF368983)),
          SizedBox(width: 8),
          Text(
            value.isEmpty ? label : value,
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Tarjeta de transacción
  Widget _transactionCard(BuildContext context, Movimiento movimiento) {
    String valor = "\$${((int.parse(movimiento.recibe1C ?? '0') * 0.01).toDouble() +
        (int.parse(movimiento.recibe5C ?? '0') * 0.05).toDouble() +
        (int.parse(movimiento.recibe10C ?? '0') * 0.1).toDouble() +
        (int.parse(movimiento.recibe25C ?? '0') * 0.25).toDouble() +
        (int.parse(movimiento.recibe50C ?? '0') * 0.5).toDouble() +
        (int.parse(movimiento.recibe1D ?? '0') * 1) +
        (int.parse(movimiento.recibe5D ?? '0') * 5) +
        (int.parse(movimiento.recibe10D ?? '0') * 10)).toStringAsFixed(2)}";

    String detalle = "${movimiento.nombreCajero}\n${movimiento.fecha}";

    return GestureDetector(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.credit_card_sharp, color: Color(0xFF368983), size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valor,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      detalle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => transaccionesController.openBottomSheet(context, movimiento),
    );
  }

  Future<String?> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Fecha mínima
      lastDate: DateTime(2100), // Fecha máxima
    );

    if (pickedDate != null) {
      return "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
    return null;
  }
}
