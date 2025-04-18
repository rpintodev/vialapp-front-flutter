import 'package:asistencia_vial_app/src/pages/supervisor/canje/canje_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class CanjePage extends StatelessWidget {

  late CanjeController canjeController;

  Usuario? usuario;

  List<Movimiento>? movimientos;



  CanjePage({@required this.usuario,@required this.movimientos}){
    canjeController=Get.put(CanjeController(usuario!,movimientos!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Canje - ${usuario!.nombre} ${usuario!.apellido}',
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
            _sectionTitle('Recibe'),
            _recibeGrid(),

            Divider(thickness: 1, color: Colors.grey[300]),

            _sectionTitle('Entrega'),
            SizedBox(height: 5),
            _entregaGrid(),
            SizedBox(height: 10),
            _confirmButton(context),
           // SizedBox(height: 10),
            //_buildAnalisisTable(), // Tabla de Análisis
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
        maxLength: 3,
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
                controller: canjeController.billetes20Controller,
                maxLength: 2,
              ),
            ),
            SizedBox(width: 5), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: canjeController.billetes10RecibeController,
                maxLength: 2,

              ),
            ),
          ],
        ),
        SizedBox(height: 5), // Espaciado vertical entre filas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: canjeController.billetes5RecibeController,
                maxLength: 2,
              ),
            ),
            SizedBox(width: 5), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: canjeController.billetes1RecibeController,
                maxLength: 3,
              ),
            ),
          ],
        ),
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
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: canjeController.billetes10EntregaController,
                maxLength: 2,
              ),
            ),
            SizedBox(width: 5), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: canjeController.billetes5EntregaController,
                maxLength: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: 5), // Espaciado vertical entre filas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: canjeController.billetes1EntregaController,
                maxLength: 3,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 50',
                assetIcon: 'assets/img/moneda.png',
                controller: canjeController.moneda50EntregaController,
                maxLength: 3,
              ),
            ),
          ],
        ),        SizedBox(height: 5), // Espaciado vertical entre filas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 25',
                assetIcon: 'assets/img/moneda.png',
                controller: canjeController.moneda25EntregaController,
                maxLength: 3,
              ),
            ),
            SizedBox(width: 10), // Espaciado horizontal entre columnas
            Expanded(
              child: Container(),
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
    final billetes20 = canjeController.billetes20Controller.text.isEmpty
        ? '0'
        : canjeController.billetes20Controller.text;
    final billetes10Recibe = canjeController.billetes10RecibeController.text.isEmpty
        ? '0'
        : canjeController.billetes10RecibeController.text;
    final billetes5Recibe = canjeController.billetes5RecibeController.text.isEmpty
        ? '0'
        : canjeController.billetes5RecibeController.text;
    final billetes1Recibe = canjeController.billetes1RecibeController.text.isEmpty
        ? '0'
        : canjeController.billetes1RecibeController.text;

    final billetes10Entrega = canjeController.billetes10EntregaController.text.isEmpty
        ? '0'
        : canjeController.billetes10EntregaController.text;
    final billetes5Entrega = canjeController.billetes5EntregaController.text.isEmpty
        ? '0'
        : canjeController.billetes5EntregaController.text;
    final billetes1Entrega = canjeController.billetes1EntregaController.text.isEmpty
        ? '0'
        : canjeController.billetes1EntregaController.text;
final moneda50Entrega = canjeController.moneda50EntregaController.text.isEmpty
        ? '0'
        : canjeController.moneda50EntregaController.text;
final moneda25Entrega = canjeController.moneda25EntregaController.text.isEmpty
        ? '0'
        : canjeController.moneda25EntregaController.text;

    // Cálculo del total entregado por el supervisor
    final totalEntrega = (int.parse(billetes10Entrega) * 10) +
        (int.parse(billetes5Entrega) * 5) +
        (int.parse(billetes1Entrega) * 1) +
        (int.parse(moneda50Entrega) * 0.5).toDouble() +
        (int.parse(moneda25Entrega) * 0.25).toDouble()
    ;

    // Cálculo del total recibido por el cajero
    final totalRecibe = (int.parse(billetes10Recibe) * 10) + (int.parse(billetes20) * 20) +
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
              Text("Recibe de Cajero:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes20 billetes de \$20"),
              Text("- $billetes10Recibe billetes de \$10"),
              Text("- $billetes5Recibe billetes de \$5"),
              Text("- $billetes1Recibe monedas de \$1"),
              SizedBox(height: 5),
              Text("Total Recibido: \$${totalRecibe.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),
              Text("Entregó Supervisor:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("- $billetes10Entrega billetes de \$10"),
              Text("- $billetes5Entrega billetes de \$5"),
              Text("- $billetes1Entrega monedas de \$1"),
              Text("- $moneda50Entrega monedas de 50C"),
              Text("- $moneda25Entrega monedas de 25C"),
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
                canjeController.registarCanje(context, usuario!);
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


  Widget _buildAnalisisTable() {
    // Sumar todas las cantidades de billetes entregados y recibidos en todos los movimientos
    int totalEntregada20 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.entrega20D ?? '0') ?? 0));
    int totalEntregada10 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.entrega10D ?? '0') ?? 0));
    int totalEntregada5 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.entrega5D ?? '0') ?? 0));
    int totalEntregada1 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.entrega1D ?? '0') ?? 0));

    int totalRecibida20 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.recibe20D ?? '0') ?? 0));
    int totalRecibida10 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.recibe10D ?? '0') ?? 0));
    int totalRecibida5 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.recibe5D ?? '0') ?? 0));
    int totalRecibida1 = movimientos!.fold(0, (sum, m) => sum + (int.tryParse(m.recibe1D ?? '0') ?? 0));

    // Crear lista con los valores calculados
    final data = [
      {"denominacion": "\$20", "entregada": totalEntregada20, "recibida": totalRecibida20},
      {"denominacion": "\$10", "entregada": totalEntregada10, "recibida": totalRecibida10},
      {"denominacion": "\$5", "entregada": totalEntregada5, "recibida": totalRecibida5},
      {"denominacion": "\$1", "entregada": totalEntregada1, "recibida": totalRecibida1},
    ];

    // Validar si hay datos para mostrar
    bool hayDatos = data.any((d) => (d["entregada"] as int) > 0 || (d["recibida"] as int) > 0);
    if (!hayDatos) return SizedBox(); // No mostrar la tabla si no hay datos

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Análisis"),
        SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },
          children: [
            // Cabecera de la tabla
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                _tableCell("Denominación", isHeader: true),
                _tableCell("Entregada", isHeader: true),
                _tableCell("Recibida", isHeader: true),
                _tableCell("Índice", isHeader: true),
              ],
            ),
            // Filas de la tabla con las sumas
            ...data.map((d) {
              int entregada = d["entregada"] as int;
              int recibida = d["recibida"] as int;
              int indice =  recibida-entregada;

              return TableRow(
                children: [
                  _tableCell(d["denominacion"] as String),
                  _tableCell(entregada.toString()),
                  _tableCell(recibida.toString()),
                  _tableCell(indice.toString(), color: indice < 0 ? Colors.red : Colors.green),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  /// **Widget: Celda de Tabla**
  Widget _tableCell(String text, {bool isHeader = false, Color color = Colors.black}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: color,
        ),
      ),
    );
  }


}
