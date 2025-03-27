import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/liquidaciones/liquidaciones_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';

class LiquidacionesPage extends StatelessWidget {



  late LiquidacionesController liquidacionesController;

  Usuario? usuario;
  List<Movimiento>? movimientos;

  LiquidacionesPage({@required this.usuario,@required this.movimientos}){
    liquidacionesController=Get.put(LiquidacionesController(usuario!,movimientos!));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liquidación',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Color(0xFF368983),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle2('Recibe de Cajero'),
            _recibeGrid(),
            SizedBox(height: 10),
            Divider(thickness: 1, color: Colors.grey[300]),
            _sectionTitle('Retiros Parciales'),
            SizedBox(height: 20),
            _retirosParcialesList(),
            SizedBox(height: 30),
            _confirmButton(context),
          ],
        ),
      ),
    );
  }

  /// **Widget: Título de Sección**
  Widget _sectionTitle2(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF368983),
      ),
    );
  }



  /// **Widget: Título de Secciónnnn**
  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF368983),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            liquidacionesController.goToRetiroParcial(usuario!);
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Añadir',style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF368983),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  /// **Widget: Campo de Entrada**
  Widget _inputField({
    required String label,
    IconData? icon, // Cambiado para admitir null
    String? assetIcon, // Agregado para soportar íconos de assets
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: controller.text.isEmpty ? Colors.grey : Colors.black),
          prefixIcon: assetIcon != null
              ? Padding(
            padding: const EdgeInsets.all(10.0), // Ajuste del tamaño del ícono
            child: Image.asset(
              assetIcon,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          )
              : Icon(icon, color: Color(0xFF368983)), // Ícono estándar si no hay assetIcon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF368983)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF368983), width: 2),
          ),
        ),
      ),
    );
  }


  Widget _recibeGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$20',
                assetIcon: 'assets/img/billete.png',
                controller: liquidacionesController.billetes20Controller,
              ),
            ),
            SizedBox(width: 2), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$10',
                assetIcon: 'assets/img/billete.png',
                controller: liquidacionesController.billetes10Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$5',
                assetIcon: 'assets/img/billete.png',
                controller: liquidacionesController.billetes5Controller,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$2',
                assetIcon: 'assets/img/billete.png',
                controller: liquidacionesController.billetes2Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$1',
                assetIcon: 'assets/img/billete.png',
                controller: liquidacionesController.billetes1Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$1',
                assetIcon: 'assets/img/moneda.png',
                controller: liquidacionesController.moneda1dController,
              ),
            ),
          ],
        ),
        SizedBox(height: 8), // Espaciado vertical entre filas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: ' 50C',
                assetIcon: 'assets/img/moneda.png',
                controller: liquidacionesController.Moneda50Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 25C',
                assetIcon: 'assets/img/moneda.png',
                controller: liquidacionesController.Moneda25Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 10C',
                assetIcon: 'assets/img/moneda.png',
                controller: liquidacionesController.Moneda10Controller,
              ),
            ),
          ],
        ),

        SizedBox(height: 8), // Espaciado vertical entre filas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: ' 5 C',
                assetIcon: 'assets/img/moneda.png',
                controller: liquidacionesController.Moneda5Controller,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: ' 1 C',
                assetIcon: 'assets/img/moneda.png',
                controller: liquidacionesController.Moneda1Controller,
              ),
            ),
          ],
        ),
      ],
    );
  }




  /// **Widget: Botón de Confirmación**
  Widget _confirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _confirmLiquidacion(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Liquidar Turno',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// **Método: Confirmar Liquidación**
  void _confirmLiquidacion(BuildContext context) {
    // Validar valores vacíos y asignar 0 por defecto
    final billetes20 = liquidacionesController.billetes20Controller.text.isEmpty
        ? '0'
        : liquidacionesController.billetes20Controller.text;
    final billetes10 = liquidacionesController.billetes10Controller.text.isEmpty
        ? '0'
        : liquidacionesController.billetes10Controller.text;
    final billetes5 = liquidacionesController.billetes5Controller.text.isEmpty
        ? '0'
        : liquidacionesController.billetes5Controller.text;
    final billetes2 = liquidacionesController.billetes2Controller.text.isEmpty
        ? '0'
        : liquidacionesController.billetes2Controller.text;
    final billetes1 = liquidacionesController.billetes1Controller.text.isEmpty
        ? '0'
        : liquidacionesController.billetes1Controller.text;
    final moneda1d = liquidacionesController.moneda1dController.text.isEmpty
        ? '0'
        : liquidacionesController.moneda1dController.text;

    final moneda50 = liquidacionesController.Moneda50Controller.text.isEmpty
        ? '0'
        : liquidacionesController.Moneda50Controller.text;
    final moneda25 = liquidacionesController.Moneda25Controller.text.isEmpty
        ? '0'
        : liquidacionesController.Moneda25Controller.text;
    final moneda10 = liquidacionesController.Moneda10Controller.text.isEmpty
        ? '0'
        : liquidacionesController.Moneda10Controller.text;
    final moneda5 = liquidacionesController.Moneda5Controller.text.isEmpty
        ? '0'
        : liquidacionesController.Moneda5Controller.text;
    final moneda1 = liquidacionesController.Moneda1Controller.text.isEmpty
        ? '0'
        : liquidacionesController.Moneda1Controller.text;

    // Calcular el total de retiros parciales
    final totalRetirosParciales = movimientos?.where((m) => m.idTipoMovimiento == '2').isNotEmpty == true
        ? movimientos!.map((movimiento) {
      final recibido = (int.parse(movimiento.recibe20D ?? '0') * 20) +
          (int.parse(movimiento.recibe10D ?? '0') * 10) +
          (int.parse(movimiento.recibe5D ?? '0') * 5) +
          (int.parse(movimiento.recibe1D ?? '0') * 1);
      return recibido;
    }).reduce((sum, current) => sum + current) :
        0;

    // Calcular el total de denominaciones
    final totalDenominaciones = (int.parse(billetes20) * 20) +
        (int.parse(billetes10) * 10) +
        (int.parse(billetes5) * 5) +
        (int.parse(billetes2) * 2) +
        (int.parse(billetes1) * 1) +
        (int.parse(moneda1d) * 1) +
        (int.parse(moneda50) * 0.50).toDouble() +
        (int.parse(moneda25) * 0.25).toDouble() +
        (int.parse(moneda10) * 0.10).toDouble() +
        (int.parse(moneda5) * 0.05).toDouble() +
        (int.parse(moneda1) * 0.01).toDouble();

    // Calcular el total general (denominaciones + retiros parciales)
    final totalGeneral = totalDenominaciones + totalRetirosParciales;

    // Mostrar el diálogo de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.monetization_on, color: Color(0xFF368983)),
              SizedBox(width: 10),
              Text("Confirmación", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("¿Estás seguro de realizar esta liquidación?", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              SizedBox(height: 10),
              Text("Denominaciones:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes20 billetes de \$20"),
              Text("- $billetes10 billetes de \$10"),
              Text("- $billetes5 billetes de \$5"),
              Text("- $billetes2 billetes de \$2"),
              Text("- $billetes1 billetes de \$1"),
              Text("- $moneda1d monedas de \$1"),
              Text("- $moneda50 monedas de 50¢"),
              Text("- $moneda25 monedas de 25¢"),
              Text("- $moneda10 monedas de 10¢"),
              Text("- $moneda5 monedas de 5¢"),
              Text("- $moneda1 monedas de 1¢"),
              SizedBox(height: 10),
              Text("Total Denominaciones: \$${totalDenominaciones.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("Total Retiros Parciales: \$${totalRetirosParciales.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("Total General: \$${totalGeneral.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF368983))),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                print("Liquidación confirmada");
                liquidacionesController.registarLiquidacion(context, usuario!,movimientos!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF368983),
              ),
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }



  Widget _retirosParcialesList() {
    if (movimientos == null || movimientos!.where((m) => m.idTipoMovimiento == '2').isEmpty) {
      return Center(
        child: Text(
          'No hay retiros parciales registrados.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    final retirosparciales=movimientos?.where((m) => m.idTipoMovimiento == '2').toList();

    return ListView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: retirosparciales!.length,
      itemBuilder: (context, index) {
        final movimiento = retirosparciales![index];

        // Calcular el valor total sumando denominaciones recibidas
        final totalRecibido = (int.parse(movimiento.recibe20D ?? '0') * 20) +
            (int.parse(movimiento.recibe10D ?? '0') * 10) +
            (int.parse(movimiento.recibe5D ?? '0') * 5) +
            (int.parse(movimiento.recibe1D ?? '0') * 1);

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Color(0xFF368983), size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Vía: ${movimiento.via ?? "No registrada"}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                        SizedBox(width: 5),
                        Text(
                          movimiento.fecha ?? 'Sin fecha',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Text(
                      '\$${totalRecibido}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF368983),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
