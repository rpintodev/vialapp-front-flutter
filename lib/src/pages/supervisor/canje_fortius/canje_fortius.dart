import 'package:asistencia_vial_app/src/pages/supervisor/canje/canje_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';
import 'canje_fortius_controller.dart';

class CanjeFortiusPage extends StatelessWidget {

  late CanjeFortiusController canjefortiusController;

  Usuario? usuario;


  CanjeFortiusPage({@required this.usuario}){
    canjefortiusController=Get.put(CanjeFortiusController(usuario!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Canje de Fortius',
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
            _sectionTitle('Recibe de Fortius'),
            _recibeGrid(),
            SizedBox(height: 10),

            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 20),
            _sectionTitle('Entrega Supervisor'),
            SizedBox(height: 10),
            _entregaGrid(),
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
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: canjefortiusController.billetes5RecibeController,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: canjefortiusController.billetes1RecibeController,
              ),
            ),
          ],
        ),
        SizedBox(height: 8), // Espaciado vertical entre filas

      ],
    );
  }

  Widget _entregaGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 20',
                assetIcon: 'assets/img/billete.png',
                controller: canjefortiusController.billetes20EntregaController,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: canjefortiusController.billetes10EntregaController,
              ),
            ),
          ],
        ),
        SizedBox(height: 8), // Espaciado vertical entre filas

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
          'Confirmar Canje',
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
    // Validar valores vacíos y asignar 0 por defecto
    final billetes5Recibe = canjefortiusController.billetes5RecibeController.text.isEmpty
        ? '0'
        : canjefortiusController.billetes5RecibeController.text;
    final billetes1Recibe = canjefortiusController.billetes1RecibeController.text.isEmpty
        ? '0'
        : canjefortiusController.billetes1RecibeController.text;

    final billetes10Entrega = canjefortiusController.billetes10EntregaController.text.isEmpty
        ? '0'
        : canjefortiusController.billetes10EntregaController.text;
    final billetes20Entrega = canjefortiusController.billetes20EntregaController.text.isEmpty
        ? '0'
        : canjefortiusController.billetes20EntregaController.text;

    // Cálculo del total entregado por el supervisor
    final totalEntrega = (int.parse(billetes10Entrega) * 10) +
        (int.parse(billetes20Entrega) * 20);

    // Cálculo del total recibido de Fortius
    final totalRecibe =
        (int.parse(billetes5Recibe) * 5) +
            (int.parse(billetes1Recibe) * 1);

    // **Si los valores no coinciden, mostrar alerta de error**
    if (totalEntrega != totalRecibe) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 10),
                Text("Error en los valores", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              "Los valores entregados (\$$totalEntrega) no coinciden con los recibidos (\$$totalRecibe).\n\n"
                  "Por favor, revisa las denominaciones antes de continuar.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
                child: Text("Aceptar", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
      return; // **Sale de la función y no muestra el diálogo de confirmación**
    }

    // **Si los valores coinciden, mostrar el diálogo de confirmación**
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
              Text("¿Estás seguro de realizar este canje?", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Divider(color: Colors.grey[300]),
              SizedBox(height: 5),
              Text("Recibe de Fortius:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes5Recibe billetes de \$5"),
              Text("- $billetes1Recibe monedas de \$1"),
              SizedBox(height: 5),
              Text("Total Recibido: \$${totalRecibe.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),
              Text("Entregó Supervisor:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes20Entrega billetes de \$20"),
              Text("- $billetes10Entrega billetes de \$10"),
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
                print("Canje confirmado");
                canjefortiusController.registarCanje(context, usuario!);
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



}
