import 'package:asistencia_vial_app/src/pages/supervisor/apertura/apertura_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';

class AperturaPage extends StatelessWidget {

  late AperturaController aperturaController;

  Usuario? usuario;

  AperturaPage({@required this.usuario}){
    aperturaController=Get.put(AperturaController(usuario!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apertura - ${usuario!.nombre} ${usuario!.apellido}',
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
            _sectionTitle('Recibe de Cajero'),
            _recibeGrid(),
            SizedBox(height: 10),

            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 20),
            SizedBox(height: 30),
            _confirmButton(context),
          ],
        ),
      ),
    );
  }

  /// **Widget: Título de Sección**
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF368983),
      ),
    );
  }

  /// **Widget: Campo de Entrada**
  Widget _inputField({
    required String label,
    IconData? icon, // Cambiado para admitir null
    String? assetIcon, // Agregado para soportar íconos de assets
    required TextEditingController controller,
    int? maxLength,
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
    bool mostrarTodasDenominaciones = usuario!.idRol == '4';

    return Column(
      children: [
        // Fila de $10 y $5 (Siempre se muestra)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: aperturaController.billetes10Controller,
                maxLength: 2,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: aperturaController.billetes5Controller,
                maxLength: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),

        // Fila de $1 y otras denominaciones (Se muestran si el rol es 3)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: aperturaController.billetes1Controller,
                maxLength: 3,
              ),
            ),
            if (mostrarTodasDenominaciones) ...[
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '50c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: aperturaController.Moneda50Controller,
                  maxLength: 3,
                ),
              ),
            ]
          ],
        ),
        SizedBox(height: 8),

        // Otras denominaciones (Solo se muestran si el rol es 3)
        if (mostrarTodasDenominaciones) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField(
                  label: '25c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: aperturaController.Moneda25Controller,
                  maxLength: 3,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '10c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: aperturaController.Moneda10Controller,
                  maxLength: 3,
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
                  label: '5c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: aperturaController.Moneda5Controller,
                  maxLength: 3,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '1c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: aperturaController.Moneda1Controller,
                  maxLength: 3,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }



  /// **Widget: Botón de Confirmación**
  Widget _confirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _confirmCanje(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Confirmar Apertura',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _confirmCanje(BuildContext context) {
    bool mostrarTodasDenominaciones = usuario!.idRol == '4';

    // Validar valores vacíos y asignar 0 por defecto
    String getValue(TextEditingController controller) =>
        controller.text.isEmpty ? '0' : controller.text;

    final billetes10Entrega = getValue(aperturaController.billetes10Controller);
    final billetes5Entrega = getValue(aperturaController.billetes5Controller);
    final billetes1Entrega = getValue(aperturaController.billetes1Controller);

    // Si el usuario es idRol = 3, también incluir denominaciones pequeñas
    final moneda50Entrega = mostrarTodasDenominaciones ? getValue(aperturaController.Moneda50Controller) : '0';
    final moneda25Entrega = mostrarTodasDenominaciones ? getValue(aperturaController.Moneda25Controller) : '0';
    final moneda10Entrega = mostrarTodasDenominaciones ? getValue(aperturaController.Moneda10Controller) : '0';
    final moneda5Entrega = mostrarTodasDenominaciones ? getValue(aperturaController.Moneda5Controller) : '0';
    final moneda1Entrega = mostrarTodasDenominaciones ? getValue(aperturaController.Moneda1Controller) : '0';

    // Cálculo del total entregado por el supervisor
    final totalEntrega =
        (int.parse(billetes10Entrega) * 10) +
        (int.parse(billetes5Entrega) * 5) +
        (int.parse(billetes1Entrega) * 1) +
        (int.parse(moneda50Entrega) * 0.5).toDouble() +
        (int.parse(moneda25Entrega) * 0.25).toDouble() +
        (int.parse(moneda10Entrega) * 0.1).toDouble() +
        (int.parse(moneda5Entrega) * 0.05).toDouble() +
        (int.parse(moneda1Entrega) * 0.01).toDouble();

    // **Mostrar el diálogo de confirmación**
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.library_add_check_outlined, color: Color(0xFF368983)),
              SizedBox(width: 10),
              Text("Confirmación", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("¿Estás seguro de realizar esta apertura?", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Divider(color: Colors.grey[300]),
              SizedBox(height: 5),

              Text("Entregó Supervisor:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes10Entrega billetes de \$10"),
              Text("- $billetes5Entrega billetes de \$5"),
              Text("- $billetes1Entrega monedas de \$1"),
              if (mostrarTodasDenominaciones) ...[
                Text("- $moneda50Entrega monedas de 50c"),
                Text("- $moneda25Entrega monedas de 25c"),
                Text("- $moneda10Entrega monedas de 10c"),
                Text("- $moneda5Entrega monedas de 5c"),
                Text("- $moneda1Entrega monedas de 1c"),
              ],
              SizedBox(height: 5),

              Text("Total Entregado: \$${totalEntrega.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),
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
                aperturaController.registarApertura(context, usuario!);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF368983)),
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }


}
