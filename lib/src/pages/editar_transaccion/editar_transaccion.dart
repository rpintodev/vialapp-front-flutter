import 'package:asistencia_vial_app/src/pages/editar_transaccion/editar_transaccion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/movimiento.dart';
import '../../models/usuario.dart';

class EditarTransaccionPage extends StatelessWidget {

  late EditarTransaccionController editarTransaccionController;

  Usuario? usuario;
  Movimiento? movimiento;


  EditarTransaccionPage({@required this.movimiento}) {
    editarTransaccionController =
        Get.put(EditarTransaccionController(movimiento!));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar de transacción',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF368983),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Recibe de Cajero'),
                  _recibeGrid(),
                  SizedBox(height: 10),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _sectionTitle('Entregó Supervisor'),
                  SizedBox(height: 10),
                  _entregaGrid(),
                  SizedBox(height: 20),

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

  Widget _inputField({
    required String label,
    String? assetIcon,
    required TextEditingController controller,
    bool readOnly = false,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: assetIcon != null
              ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              assetIcon,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

      ),
    );
  }


  Widget _recibeGrid() {
   // bool mostrarTodasDenominaciones = usuario!.idRol == '4';

    return Column(
      children: [
        // Fila de $20 y $10 (Siempre se muestra)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 20',
                assetIcon: 'assets/img/billete.png',
                controller: editarTransaccionController.billetes20Controller,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: editarTransaccionController.billetes10RecibeController,
              ),
            ),
          ],
        ),        // Fila de $5 y $1 (Siempre se muestra)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: editarTransaccionController.billetes5RecibeController,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.billetes1RecibeController,
              ),
            ),
          ],
        ),

        // Otras denominaciones (Solo si el rol es 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField(
                  label: '50c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: editarTransaccionController.Moneda50RecibeController,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '25c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: editarTransaccionController.Moneda25RecibeController,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField(
                  label: '10c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: editarTransaccionController.Moneda10RecibeController,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '5c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: editarTransaccionController.Moneda5RecibeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _inputField(
                  label: '1c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: editarTransaccionController.Moneda1RecibeController,
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
        // Fila de $20 y $10 (Siempre se muestra)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 20',
                assetIcon: 'assets/img/billete.png',
                controller: editarTransaccionController.billetes20EntregaController,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: editarTransaccionController.billetes10EntregaController,
              ),
            ),
          ],
        ),        // Fila de $5 y $1 (Siempre se muestra)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: editarTransaccionController.billetes5EntregaController,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.billetes1EntregaController,
              ),
            ),
          ],
        ),

        // Otras denominaciones (Solo si el rol es 3)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '50c',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.Moneda50EntregaController,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _inputField(
                label: '25c',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.Moneda25EntregaController,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField(
                label: '10c',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.Moneda10EntregaController,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _inputField(
                label: '5c',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.Moneda5EntregaController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _inputField(
                label: '1c',
                assetIcon: 'assets/img/moneda.png',
                controller: editarTransaccionController.Moneda1EntregaController,
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
          _confirmEditartransaccion(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Editar Transacción',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  /// **Método: Confirmar Retiro de Apertura**
  void _confirmEditartransaccion(BuildContext context) {

    // Validar valores vacíos y asignar 0 por defecto
    String getValue(TextEditingController controller) =>
        controller.text.isEmpty ? '0' : controller.text;

    // Obtener los valores de los controladores
    final billetes20Recibe = getValue(editarTransaccionController.billetes20Controller);
    final billetes10Recibe = getValue(editarTransaccionController.billetes10RecibeController);
    final billetes5Recibe = getValue(editarTransaccionController.billetes5RecibeController);
    final billetes1Recibe = getValue(editarTransaccionController.billetes1RecibeController);

    final billetes20Entrega = getValue(editarTransaccionController.billetes20Controller);
    final billetes10Entrega = getValue(editarTransaccionController.billetes10EntregaController);
    final billetes5Entrega = getValue(editarTransaccionController.billetes5EntregaController);
    final billetes1Entrega = getValue(editarTransaccionController.billetes1EntregaController);

    final moneda50Recibe = getValue(editarTransaccionController.Moneda50RecibeController);
    final moneda25Recibe = getValue(editarTransaccionController.Moneda25RecibeController);
    final moneda10Recibe = getValue(editarTransaccionController.Moneda10RecibeController);
    final moneda5Recibe = getValue(editarTransaccionController.Moneda5RecibeController);
    final moneda1Recibe = getValue(editarTransaccionController.Moneda1RecibeController);

    final moneda50Entrega = getValue(editarTransaccionController.Moneda50EntregaController);
    final moneda25Entrega = getValue(editarTransaccionController.Moneda25EntregaController);
    final moneda10Entrega = getValue(editarTransaccionController.Moneda10EntregaController);
    final moneda5Entrega = getValue(editarTransaccionController.Moneda5EntregaController);
    final moneda1Entrega = getValue(editarTransaccionController.Moneda1EntregaController);

    // Cálculo del total entregado por el supervisor
    final totalEntrega =(int.parse(billetes20Entrega) * 20)+ (int.parse(billetes10Entrega) * 10) +
        (int.parse(billetes5Entrega) * 5) +
        (int.parse(billetes1Entrega) * 1) +
        (int.parse(moneda50Entrega) * 0.5).toDouble() +
        (int.parse(moneda25Entrega) * 0.25).toDouble() +
        (int.parse(moneda10Entrega) * 0.1).toDouble() +
        (int.parse(moneda5Entrega) * 0.05).toDouble() +
        (int.parse(moneda1Entrega) * 0.01).toDouble();

    // Cálculo del total recibido por el cajero
    final totalRecibe = (int.parse(billetes20Recibe) * 20) +
        (int.parse(billetes10Recibe) * 10) +
        (int.parse(billetes5Recibe) * 5) +
        (int.parse(billetes1Recibe) * 1) +
        (int.parse(moneda50Recibe) * 0.5).toDouble() +
        (int.parse(moneda25Recibe) * 0.25).toDouble() +
        (int.parse(moneda10Recibe) * 0.1).toDouble() +
        (int.parse(moneda5Recibe) * 0.05).toDouble() +
        (int.parse(moneda1Recibe) * 0.01).toDouble();


    // **Mostrar las denominaciones según el tipo de movimiento**
    List<Widget> _getDenominacionesRecibe() {
      switch (movimiento!.idTipoMovimiento) {
        case '1': // Apertura
          return [
            Text("- $billetes20Recibe billetes de \$20"),
            Text("- $billetes10Recibe billetes de \$10"),
            Text("- $billetes5Recibe billetes de \$5"),
            Text("- $billetes1Recibe monedas de \$1"),
            Text("- $moneda50Recibe monedas de 50c"),
            Text("- $moneda25Recibe monedas de 25c"),
            Text("- $moneda10Recibe monedas de 10c"),
            Text("- $moneda5Recibe monedas de 5c"),
            Text("- $moneda1Recibe monedas de 1c"),
          ];
        case '2': // Retiro Parcial
          return [
            Text("- $billetes20Recibe billetes de \$20"),
            Text("- $billetes10Recibe billetes de \$10"),
            Text("- $billetes5Recibe billetes de \$5"),
            Text("- $billetes1Recibe monedas de \$1"),
          ];
        case '3': // Canje
          return [
            Text("- $billetes20Recibe billetes de \$20"),
            Text("- $billetes10Recibe billetes de \$10"),
            Text("- $billetes5Recibe billetes de \$5"),
            Text("- $billetes1Recibe monedas de \$1"),
          ];
        case '4': // Liquidación
          return [
            Text("- $billetes20Recibe billetes de \$20"),
            Text("- $billetes10Recibe billetes de \$10"),
            Text("- $billetes5Recibe billetes de \$5"),
            Text("- $billetes1Recibe monedas de \$1"),
            Text("- $moneda50Recibe monedas de 50c"),
            Text("- $moneda25Recibe monedas de 25c"),
            Text("- $moneda10Recibe monedas de 10c"),
            Text("- $moneda5Recibe monedas de 5c"),
            Text("- $moneda1Recibe monedas de 1c"),
          ];
        case '5': // Fortius
          return [
            Text("- $billetes5Recibe billetes de \$5"),
            Text("- $billetes1Recibe monedas de \$1"),
          ];
        default:
          return [Text("No hay denominaciones para este tipo de movimiento.")];
      }
    }

    List<Widget> _getDenominacionesEntrega() {
      switch (movimiento!.idTipoMovimiento) {
        case '1': // Apertura
          return [
            Text("- $billetes10Entrega billetes de \$10"),
            Text("- $billetes5Entrega billetes de \$5"),
            Text("- $billetes1Entrega monedas de \$1"),
            Text("- $moneda50Entrega monedas de 50c"),
            Text("- $moneda25Entrega monedas de 25c"),
            Text("- $moneda10Entrega monedas de 10c"),
            Text("- $moneda5Entrega monedas de 5c"),
            Text("- $moneda1Entrega monedas de 1c"),
          ];
        case '3': // Canje
          return [
            Text("- $billetes20Entrega billetes de \$20"),
            Text("- $billetes10Entrega billetes de \$10"),
            Text("- $billetes5Entrega billetes de \$5"),
            Text("- $billetes1Entrega monedas de \$1"),
          ];
        case '5': // Fortius
          return [
            Text("- $billetes20Recibe billetes de \$20"),
            Text("- $billetes10Recibe billetes de \$10"),
            Text("- $billetes5Recibe billetes de \$5"),
            Text("- $billetes1Recibe monedas de \$1"),
            Text("- $moneda50Recibe monedas de 50c"),
            Text("- $moneda25Recibe monedas de 25c"),
            Text("- $moneda10Recibe monedas de 10c"),
            Text("- $moneda5Recibe monedas de 5c"),
            Text("- $moneda1Recibe monedas de 1c"),
          ];
        default:
          return []; // No hay denominaciones de entrega para otros tipos
      }
    }


    // **Mostrar el diálogo de confirmación con las denominaciones correspondientes**
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.library_add_check_outlined, color: Color(0xFF368983)),
                    SizedBox(width: 10),
                    Text(movimiento?.nombreMovimiento??'', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("¿Estás seguro de editar esta transacción?", style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Divider(color: Colors.grey[300]),
                SizedBox(height: 5),

                Text("Recibe de Cajero:", style: TextStyle(fontWeight: FontWeight.bold)),
                ..._getDenominacionesRecibe(), // Muestra las denominaciones de recibe
            SizedBox(height: 5),

            Text("Total Recibido: \$${totalRecibe.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),

            if (_getDenominacionesEntrega().isNotEmpty) ...[
        Text("Entregó Supervisor:", style: TextStyle(fontWeight: FontWeight.bold)),
        ..._getDenominacionesEntrega(), // Muestra las denominaciones de entrega
        SizedBox(height: 5),

        Text("Total Entregado: \$${totalEntrega.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),
        ],
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
        Navigator.of(context).pop();
        editarTransaccionController.editarTransaccion(context, movimiento!);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF368983)),
        child: Text("Confirmar"),
        ),
        ],
        ),
        );
      },
    );


  }


}
