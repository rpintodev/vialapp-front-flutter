import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:asistencia_vial_app/src/pages/admin/modificar_boveda/modificar_boveda_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ModificarBoveda extends StatelessWidget {

  late ModificarBovedaController modificarBovedaController;
  Boveda? boveda;

  ModificarBoveda({@required this.boveda}){
    modificarBovedaController=Get.put(ModificarBovedaController(boveda!));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modificar Boveda',
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
            _sectionTitle('Denominaciónes en Bóveda'),
            SizedBox(height: 5),
            _recibeGrid(),
            SizedBox(height: 10),
            Divider(thickness: 1, color: Colors.grey[300]),
            _sectionTitle('Observación'),
            SizedBox(height: 5),
            _reasonField(),
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
                label: '\$20',
                assetIcon: 'assets/img/billete.png',
                controller: modificarBovedaController.billetes20Controller,
              ),
            ),
            SizedBox(width: 2), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$10',
                assetIcon: 'assets/img/billete.png',
                controller: modificarBovedaController.billetes10Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$5',
                assetIcon: 'assets/img/billete.png',
                controller: modificarBovedaController.billetes5Controller,
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
                controller: modificarBovedaController.billetes2Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$1',
                assetIcon: 'assets/img/billete.png',
                controller: modificarBovedaController.billetes1Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$1',
                assetIcon: 'assets/img/moneda.png',
                controller: modificarBovedaController.moneda1dController,
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
                controller: modificarBovedaController.Moneda50Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 25C',
                assetIcon: 'assets/img/moneda.png',
                controller: modificarBovedaController.Moneda25Controller,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 10C',
                assetIcon: 'assets/img/moneda.png',
                controller: modificarBovedaController.Moneda10Controller,
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
                controller: modificarBovedaController.Moneda5Controller,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: ' 1 C',
                assetIcon: 'assets/img/moneda.png',
                controller: modificarBovedaController.Moneda1Controller,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _reasonField() {
    return TextField(
      controller: modificarBovedaController.ObservacionController,
      maxLines: 5, // Más líneas para mayor altura
      decoration: InputDecoration(
        labelText: 'Escriba el motivo del cambio',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  /// **Widget: Botón de Confirmación**
  Widget _confirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _confirmModificacion(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Modificar Boveda',
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
  void _confirmModificacion(BuildContext context) {
    // Validar valores vacíos y asignar 0 por defecto
    final billetes20 = modificarBovedaController.billetes20Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.billetes20Controller.text;
    final billetes10 = modificarBovedaController.billetes10Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.billetes10Controller.text;
    final billetes5 = modificarBovedaController.billetes5Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.billetes5Controller.text;
    final billetes2 = modificarBovedaController.billetes2Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.billetes2Controller.text;
    final billetes1 = modificarBovedaController.billetes1Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.billetes1Controller.text;
    final moneda1d = modificarBovedaController.moneda1dController.text.isEmpty
        ? '0'
        : modificarBovedaController.moneda1dController.text;

    final moneda50 = modificarBovedaController.Moneda50Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.Moneda50Controller.text;
    final moneda25 = modificarBovedaController.Moneda25Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.Moneda25Controller.text;
    final moneda10 = modificarBovedaController.Moneda10Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.Moneda10Controller.text;
    final moneda5 = modificarBovedaController.Moneda5Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.Moneda5Controller.text;
    final moneda1 = modificarBovedaController.Moneda1Controller.text.isEmpty
        ? '0'
        : modificarBovedaController.Moneda1Controller.text;



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
              Text("Total Boveda: \$${totalDenominaciones.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
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
                modificarBovedaController.actualizarBoveda(context, boveda!);
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
