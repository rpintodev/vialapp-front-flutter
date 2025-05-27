import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/pages/transacciones/transacciones_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transacciones extends StatelessWidget {

  TransaccionesController transaccionesController = Get.put(TransaccionesController());
  int? index2;


  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
      length: transaccionesController.tipoMovimientos.length,
      child: Scaffold(
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
                              _checkAndSearch();
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
                              _checkAndSearch();
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
            bottom: TabBar(
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              indicatorColor: Color(0xFF368983),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              tabs: transaccionesController.tipoMovimientos
                  .map((tipo) => Tab(text: tipo.nombreMovimiento ?? ' '))
                  .toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: List.generate(transaccionesController.tipoMovimientos.length, (index) {
            return _buildTabContent(index + 1);
          }),
        ),
      ),
    ));
  }

  /// Construye el contenido de cada pestaña dinámicamente
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
              return _transactionCard(context, snapshot.data![index], idTipoMovimiento);
            },
          );
        }
        return Center(child: Text("No hay datos disponibles"));
      },
    );
  }

  void _checkAndSearch() {
    if (transaccionesController.fechaInicio.isNotEmpty &&
        transaccionesController.fechaFin.isNotEmpty) {
      int currentIndex = DefaultTabController.of(Get.context!)?.index ?? 0;
      int idTipoMovimiento = currentIndex + 1;

      transaccionesController.getMovimientos(
        transaccionesController.fechaInicio.value,
        transaccionesController.fechaFin.value,
        idTipoMovimiento.toString(),
        transaccionesController.usuarioSession.idPeaje ?? '1',
      );
    }
  }


  /// Limpia los filtros y actualiza las pestañas
  void _clearFilters() {
    transaccionesController.fechaInicio.value = '';
    transaccionesController.fechaFin.value = '';
    _checkAndSearch(); // Reinicia la búsqueda sin filtros
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


  /// Tarjetas según el tipo de movimiento
  Widget _transactionCard(BuildContext context,Movimiento movimiento, int idTipoMovimiento) {
    String valor;
    String detalle;
    IconData icono=Icons.paid_outlined; // Ícono predeterminado
    switch (idTipoMovimiento) {
      case 1: // Apertura
        valor = "\$${(int.parse(movimiento.entrega1D??'0') * 1) +(int.parse(movimiento.entrega50C??'0') * 0.5).toDouble() +(int.parse(movimiento.entrega25C??'0') * 0.25).toDouble() + (int.parse(movimiento.entrega5D??'0') * 5) + (int.parse(movimiento.entrega10D??'0') * 10)}";
        detalle = "${movimiento.nombreCajero}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno ${movimiento.turno}";
        icono= Icons.paid_outlined;

        break;
      case 2: // Retiros Parciales
        valor = "\$${(int.parse(movimiento.recibe1D??'0') * 1) + (int.parse(movimiento.recibe5D??'0') * 5) + (int.parse(movimiento.recibe10D??'0') * 10)+ (int.parse(movimiento.recibe20D??'0') * 20)}";
        detalle = "${movimiento.nombreCajero}\nVía ${movimiento.via}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno ${movimiento.turno}";
        icono= Icons.payments_outlined;

        break;
      case 3: // Canje
        valor = "\$${(int.parse(movimiento.recibe1D??'0') * 1) + (int.parse(movimiento.recibe5D??'0') * 5) + (int.parse(movimiento.recibe10D??'0') * 10)+ (int.parse(movimiento.recibe20D??'0') * 20)}";
        detalle = "${movimiento.nombreCajero}\nVía ${movimiento.via}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno ${movimiento.turno}";
        icono= Icons.currency_exchange;

        break;
      case 4: // Liquidaciones
        valor = "\$${((int.parse(movimiento.recibe1C??'0') * 0.01) + (int.parse(movimiento.recibe5C??'0') * 0.05) + (int.parse(movimiento.recibe10C??'0') * 0.1) + (int.parse(movimiento.recibe25C??'0') * 0.25) + (int.parse(movimiento.recibe50C??'0') * 0.5)+ (int.parse(movimiento.recibe2D??'0') * 2)+
                (int.parse(movimiento.recibe1D??'0') * 1) + (int.parse(movimiento.recibe1DB??'0') * 1) + (int.parse(movimiento.recibe5D??'0') * 5) + (int.parse(movimiento.recibe10D??'0') * 10)+ (int.parse(movimiento.recibe20D??'0') * 20)).toStringAsFixed(2)}";
        detalle = "${movimiento.nombreCajero}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno: ${movimiento.turno}";
        icono= Icons.request_page_outlined;

        break;
      case 5: // Fortius
        valor = "\$${((int.parse(movimiento.entrega1C??'0') * 0.01) + (int.parse(movimiento.entrega5C??'0') * 0.05) + (int.parse(movimiento.entrega10C??'0') * 0.1) + (int.parse(movimiento.entrega25C??'0') * 0.25) + (int.parse(movimiento.entrega50C??'0') * 0.5)+
            (int.parse(movimiento.entrega1D??'0') * 1) + (int.parse(movimiento.entrega5D??'0') * 5) + (int.parse(movimiento.entrega10D??'0') * 10)+ (int.parse(movimiento.entrega20D??'0') * 20)).toStringAsFixed(2)}";
        detalle = "${movimiento.nombreSupervisor}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno ${movimiento.turno}";
        icono= Icons.directions_car;

        break;
      case 6: // Liquidaciones
        valor = "\$${(((int.parse(movimiento.recibe1C??'0') * 0.01) + (int.parse(movimiento.recibe5C??'0') * 0.05) + (int.parse(movimiento.recibe10C??'0') * 0.1) + (int.parse(movimiento.recibe25C??'0') * 0.25) + (int.parse(movimiento.recibe50C??'0') * 0.5)+ (int.parse(movimiento.recibe2D??'0') * 2)+
            (int.parse(movimiento.recibe1D??'0') * 1) + (int.parse(movimiento.recibe1DB??'0') * 1) + (int.parse(movimiento.recibe5D??'0') * 5) + (int.parse(movimiento.recibe10D??'0') * 10)+ (int.parse(movimiento.recibe20D??'0') * 20))-((int.parse(movimiento.entrega1C??'0') * 0.01) + (int.parse(movimiento.entrega5C??'0') * 0.05) + (int.parse(movimiento.entrega10C??'0') * 0.1) + (int.parse(movimiento.entrega25C??'0') * 0.25) + (int.parse(movimiento.entrega50C??'0') * 0.5)+
            (int.parse(movimiento.entrega1D??'0') * 1) + (int.parse(movimiento.entrega1DB??'0') * 1) + (int.parse(movimiento.entrega5D??'0') * 5) + (int.parse(movimiento.entrega10D??'0') * 10)+ (int.parse(movimiento.entrega20D??'0') * 20))).toStringAsFixed(2)}";
        detalle = "${movimiento.nombreCajero}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno ${movimiento.turno}";
        icono= Icons.error_outline;
        break;

      case 7:
        valor = "\$${((int.parse(movimiento.recibe1C??'0') * 0.01) + (int.parse(movimiento.recibe5C??'0') * 0.05) + (int.parse(movimiento.recibe10C??'0') * 0.1) + (int.parse(movimiento.recibe25C??'0') * 0.25) + (int.parse(movimiento.recibe50C??'0') * 0.5)+ (int.parse(movimiento.recibe2D??'0') * 2)+
            (int.parse(movimiento.recibe1D??'0') * 1) + (int.parse(movimiento.recibe1DB??'0') * 1) + (int.parse(movimiento.recibe5D??'0') * 5) + (int.parse(movimiento.recibe10D??'0') * 10)+ (int.parse(movimiento.recibe20D??'0') * 20)).toStringAsFixed(2)}";
        detalle = "${movimiento.nombreCajero}\n${formatDate(DateTime.parse(movimiento.fecha??'0'), [dd, '/', mm, '/', yyyy,])}\nTurno ${movimiento.turno}";
        icono= Icons.credit_card_sharp;


        break;
      default:
        valor = "\$0.00";
        detalle = "Información no disponible";
    }

    return GestureDetector(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icono,
                color: Color(0xFF368983),
                size: 40,
              ),
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
      onTap: ()=> transaccionesController.openBottomSheet(context, movimiento,transaccionesController.bandera.value),
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
      // Devuelve la fecha seleccionada como una cadena en formato deseado
      return "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
    return null; // Retorna nulo si no se seleccionó una fecha
  }



}
