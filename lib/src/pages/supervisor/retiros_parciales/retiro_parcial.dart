import 'package:asistencia_vial_app/src/pages/supervisor/retiros_parciales/retiro_parcial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';



class RetiroParcialPage extends StatelessWidget {

  late RetiroParcialController retiroParcialController;

  Usuario? usuario;


  RetiroParcialPage({@required this.usuario}){
    retiroParcialController=Get.put(RetiroParcialController(usuario!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Retiro Parcial - ${usuario!.nombre} ${usuario!.apellido}',
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
        maxLength: 3,
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
                label: '\$ 20',
                assetIcon: 'assets/img/billete.png',
                controller: retiroParcialController.billetes20Controller,
                  maxLength: 2,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: retiroParcialController.billetes10RecibeController,
                maxLength: 2,

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
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: retiroParcialController.billetes5RecibeController,
                maxLength: 2,

              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroParcialController.billetes1RecibeController,
                maxLength: 2,

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
          _confirmRetiroParcial(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Confirmar Retiro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// **Método: Confirmar Retiro Parcial**
  void _confirmRetiroParcial(BuildContext context) {
    // Validar valores vacíos y asignar 0 por defecto
    final billetes20 = retiroParcialController.billetes20Controller.text.isEmpty
        ? '0'
        : retiroParcialController.billetes20Controller.text;
    final billetes10 = retiroParcialController.billetes10RecibeController.text.isEmpty
        ? '0'
        : retiroParcialController.billetes10RecibeController.text;
    final billetes5 = retiroParcialController.billetes5RecibeController.text.isEmpty
        ? '0'
        : retiroParcialController.billetes5RecibeController.text;
    final billetes1 = retiroParcialController.billetes1RecibeController.text.isEmpty
        ? '0'
        : retiroParcialController.billetes1RecibeController.text;

    // Cálculo del total entregado por el supervisor
    final totalRecibe = (int.parse(billetes10) * 10) + (int.parse(billetes20) * 20)+
        (int.parse(billetes5) * 5) +
        (int.parse(billetes1) * 1);

    // Mostrar el diálogo de confirmación
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
              Text("¿Estás seguro de realizar este retiro?", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Divider(color: Colors.grey[300]),
              SizedBox(height: 5),
              Text("Recibes:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes20 billetes de \$20"),
              Text("- $billetes10 billetes de \$10"),
              Text("- $billetes5 billetes de \$5"),
              Text("- $billetes1 monedas de \$1"),
              SizedBox(height: 5),
              Text("Total Recibido: \$${totalRecibe.toStringAsFixed(2)}",
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
                print("Retiro Parcial confirmado");
                retiroParcialController.registarRetiroParcial(context, usuario!);
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






