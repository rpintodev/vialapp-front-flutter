import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/movimiento.dart';
import 'detalle_cajero_controller.dart';

class DetalleCajero extends StatelessWidget {


  List<Movimiento>? movimientos;
  late DetalleCajeroController detalleCajeroController;

  DetalleCajero({@required this.movimientos}) {
    detalleCajeroController = Get.put(DetalleCajeroController(movimientos!));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              'Detalle de Transacciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: movimientos?.length,
              itemBuilder: (context, index) {
                final movimiento = movimientos?[index];
                return _buildTransactionCard(movimiento!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Movimiento movimiento) {
    // Calcula el valor total sumando denominaciones recibidas
    final totalRecibido = (int.parse(movimiento.recibe20D ?? '0') * 20) +
        (int.parse(movimiento.recibe10D ?? '0') * 10) + (int.parse(movimiento.recibe5D ?? '0') * 5) +
        (int.parse(movimiento.recibe1D ?? '0') * 1)+(int.parse(movimiento.recibe2D ?? '0') * 2)+
        (int.parse(movimiento.recibe50C ?? '0') * 0.5)+(int.parse(movimiento.recibe25C ?? '0') * 0.25)+
        (int.parse(movimiento.recibe10C ?? '0') * 0.1)+(int.parse(movimiento.recibe5C ?? '0') * 0.05)+
        (int.parse(movimiento.recibe1C ?? '0') * 0.01);

    final totalEntregado =
        (int.parse(movimiento.entrega10D ?? '0') * 10) +
        (int.parse(movimiento.entrega5D ?? '0') * 5) +
        (int.parse(movimiento.entrega1D ?? '0') * 1);


    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: Icon(
          movimiento.idTipoMovimiento == '1'
              ? Icons.paid_outlined
              : movimiento.idTipoMovimiento == '2'
              ? Icons.payments_outlined
              : movimiento.idTipoMovimiento == '3'
              ? Icons.currency_exchange
              : movimiento.idTipoMovimiento == '4'
              ? Icons.request_page_outlined
              : Icons.directions_car,
          color: Color(0xFF368983),
          size: 30,
        ),
        title: Text(
          movimiento.nombreMovimiento ?? 'Sin Tipo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          movimiento.fecha ?? 'Sin Fecha',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: Text(
          movimiento.idTipoMovimiento=='1'?
          '\$${totalEntregado}':'\$${totalRecibido}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF368983),
          ),
        ),
      ),
    );
  }
}
