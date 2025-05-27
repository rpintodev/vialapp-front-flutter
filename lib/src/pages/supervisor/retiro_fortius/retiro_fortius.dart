import 'package:asistencia_vial_app/src/pages/supervisor/retiro_fortius/retiro_fortius_controller.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiros_parciales/retiro_parcial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';



class RetiroFortiusPage extends StatelessWidget {

  late RetiroFortiusController retiroFortiusController;

  Usuario? usuario;

  RetiroFortiusPage({@required this.usuario}){
    retiroFortiusController=Get.put(RetiroFortiusController(usuario!));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(
      appBar: AppBar(
        title: Text(
          'Depósito Fortius',
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
            _sectionTitle('Entrega Supervisor'),
            _recibeGrid(),
            SizedBox(height: 10),

            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 10),

            _radioButtonTurno(context),
            SizedBox(height: 20),
            SizedBox(height: 30),
            _confirmButton(context),
          ],
        ),
      ),
    ));
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
                label: '\$ 20',
                assetIcon: 'assets/img/billete.png',
                controller: retiroFortiusController.billetes20Controller,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: retiroFortiusController.billetes10EntregaController,
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
                controller: retiroFortiusController.billetes5EntregaController,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroFortiusController.billetes1EntregaController,
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
                label: ' 50 C',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroFortiusController.Moneda50EntregaController,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: ' 25 C',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroFortiusController.Moneda25EntregaController,
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
                label: ' 10C',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroFortiusController.Moneda10EntregaController,
              ),
            ),
            SizedBox(width: 2), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: ' 5C',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroFortiusController.Moneda5EntregaController,
              ),

            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 1C',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroFortiusController.Moneda1EntregaController,
              ),

            ),
          ],
        ),
      ],
    );
  }

  Widget _radioButtonTurno(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            int turno = index + 1;
            bool isSelected = retiroFortiusController.selectedTurno.value == turno;

            return GestureDetector(
              onTap: () {

                  retiroFortiusController.selectedTurno.value = turno;

              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  'Turno $turno',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }


  void _showTurnoConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error!"),
          content: Text(
            "No se ha seleccionado el turno a depositar",
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text("Regresar"),
            ),
          ],
        );
      },
    );
  }


  /// **Widget: Botón de Confirmación**
  Widget _confirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          retiroFortiusController.selectedTurno.value!=0?
          _confirmRetiroParcial(context):
          _showTurnoConfirmationDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Confirmar Deposito',
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
    final billetes20 = retiroFortiusController.billetes20Controller.text.isEmpty
        ? '0'
        : retiroFortiusController.billetes20Controller.text;
    final billetes10 = retiroFortiusController.billetes10EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.billetes10EntregaController.text;
    final billetes5 = retiroFortiusController.billetes5EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.billetes5EntregaController.text;
    final billetes1 = retiroFortiusController.billetes1EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.billetes1EntregaController.text;
    final Moneda50 = retiroFortiusController.Moneda50EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.Moneda50EntregaController.text;
    final Moneda25 = retiroFortiusController.Moneda25EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.Moneda25EntregaController.text;
    final Moneda10 = retiroFortiusController.Moneda10EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.Moneda10EntregaController.text;
    final Moneda5 = retiroFortiusController.Moneda5EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.Moneda5EntregaController.text;
    final Moneda1 = retiroFortiusController.Moneda1EntregaController.text.isEmpty
        ? '0'
        : retiroFortiusController.Moneda1EntregaController.text;

    // Cálculo del total entregado por el supervisor
    final totalRecibe = (int.parse(billetes10) * 10) + (int.parse(billetes20) * 20)+
        (int.parse(billetes5) * 5) + (int.parse(billetes1) * 1)+
        (int.parse(Moneda50) * 0.5)+ (int.parse(Moneda25) * 0.25)+
        (int.parse(Moneda10) * 0.1)+ (int.parse(Moneda5) * 0.05)+ (int.parse(Moneda1) * 0.01);

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
              Text("- $billetes1 billetes de \$1"),
              Text("- $Moneda50 Moneda de 50C"),
              Text("- $Moneda25 Moneda de 25C"),
              Text("- $Moneda10 Moneda de 10C"),
              Text("- $Moneda5 Moneda de 5C"),
              Text("- $Moneda1 Moneda de 1C"),
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
                retiroFortiusController.registarRetiroParcial(context, usuario!);
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






