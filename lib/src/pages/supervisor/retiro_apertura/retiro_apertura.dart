import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/pages/supervisor/retiro_apertura/retiro_apertura_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';



class RetiroAperturaPage extends StatelessWidget {

  late RetiroAperturaController retiroAperturaController;

  Usuario? usuario;
  Movimiento? movimiento;


  RetiroAperturaPage({@required this.usuario, @required this.movimiento}) {
    retiroAperturaController =
        Get.put(RetiroAperturaController(usuario!, movimiento!));
    retiroAperturaController.verificarApertura();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Retiro de Apertura - ${usuario!.nombre} ${usuario!.apellido}',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF368983),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Obx(
              () =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Recibe de Cajero'),
                  _recibeGrid(!retiroAperturaController.enProgresoApertura.value &&
                      retiroAperturaController.aperturaCompleta.value),
                  SizedBox(height: 10),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _sectionTitle('Entregó Supervisor'),
                  SizedBox(height: 10),
                  _entregaGrid(),
                  SizedBox(height: 10),
                  _statusMessage(),
                  SizedBox(height: 20),
                  if (!retiroAperturaController.aperturaCompleta.value)
                    _confirmButton(context),
                ],
              ),
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
        maxLength: label=='\$ 1'?3:2,
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

  Widget _inputField2({
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


  Widget _recibeGrid(bool aperturaCompleta) {
    bool mostrarTodasDenominaciones = usuario!.idRol == '4';

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
                  controller: retiroAperturaController.billetes20Controller,
                  readOnly: aperturaCompleta,
                ),
              ),
           SizedBox(width: 5),
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: retiroAperturaController.billetes10RecibeController,
                readOnly: aperturaCompleta,
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
                controller: retiroAperturaController.billetes5RecibeController,
                readOnly: aperturaCompleta,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroAperturaController.billetes1RecibeController,
                readOnly: aperturaCompleta,
              ),
            ),
          ],
        ),

        // Otras denominaciones (Solo si el rol es 3)
        if (mostrarTodasDenominaciones) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField(
                  label: '50c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda50RecibeController,
                  readOnly: aperturaCompleta,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '25c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda25RecibeController,
                  readOnly: aperturaCompleta,
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
                  controller: retiroAperturaController.Moneda10RecibeController,
                  readOnly: aperturaCompleta,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: '5c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda5RecibeController,
                  readOnly: aperturaCompleta,
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
                  controller: retiroAperturaController.Moneda1RecibeController,
                  readOnly: aperturaCompleta,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _entregaGrid() {
    bool mostrarTodasDenominaciones = usuario!.idRol == '4';

    return Column(
      children: [
        // Fila de $20 y $10 (Siempre se muestra si idRol = 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField2(
                  label: '\$ 10',
                  assetIcon: 'assets/img/billete.png',
                  controller: retiroAperturaController.billetes10EntregaController,
                  readOnly: true,
                ),
              ),SizedBox(width: 10),
              Expanded(
                child: _inputField2(
                  label: '\$ 5',
                  assetIcon: 'assets/img/billete.png',
                  controller: retiroAperturaController.billetes5EntregaController,
                  readOnly: true,
                ),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _inputField2(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroAperturaController.billetes1EntregaController,
                readOnly: true,
              ),
            ),SizedBox(width: 10),
            if (mostrarTodasDenominaciones)...[
              Expanded(
              child: _inputField2(
                label: '50c',
                assetIcon: 'assets/img/moneda.png',
                controller: retiroAperturaController.Moneda50EntregaController,
                readOnly: true,
              ),
            ),
          ],
          ],
        ),
        if (mostrarTodasDenominaciones)...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField2(
                  label: '25c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda25EntregaController,
                  readOnly: true,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _inputField2(
                  label: '10c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda10EntregaController,
                  readOnly: true,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _inputField2(
                  label: '5c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda5EntregaController,
                  readOnly: true,
                ),
              ),SizedBox(width: 10),
              Expanded(
                child: _inputField2(
                  label: '1c',
                  assetIcon: 'assets/img/moneda.png',
                  controller: retiroAperturaController.Moneda1EntregaController,
                  readOnly: true,
                ),
              ),
            ],
          ),
         ],
      ],
    );
  }


  Widget _statusMessage() {
    final totalEntregado = retiroAperturaController.Entregado.value;
    final totalRecibido = retiroAperturaController.Recibido.value;
    final diferencia = totalEntregado - totalRecibido;

    if (diferencia == 0) {
      return Text(
        "La apertura está completa.",
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        "La apertura está incompleta. Falta: \$${diferencia.abs()
            .toStringAsFixed(2)}",
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }


  /// **Widget: Botón de Confirmación**
  Widget _confirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _confirmRetiroApertura(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Retirar Apertura',
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
  void _confirmRetiroApertura(BuildContext context) {

    bool mostrarTodasDenominaciones = usuario!.idRol == '4';

    // Validar valores vacíos y asignar 0 por defecto
    String getValue(TextEditingController controller) =>
        controller.text.isEmpty ? '0' : controller.text;

    final billetes20 = getValue(retiroAperturaController.billetes20Controller);
    final billetes10Recibe = getValue(retiroAperturaController.billetes10RecibeController);
    final billetes5Recibe = getValue(retiroAperturaController.billetes5RecibeController);
    final billetes1Recibe = getValue(retiroAperturaController.billetes1RecibeController);

    final billetes10Entrega = getValue(retiroAperturaController.billetes10EntregaController);
    final billetes5Entrega = getValue(retiroAperturaController.billetes5EntregaController);
    final billetes1Entrega = getValue(retiroAperturaController.billetes1EntregaController);

    // Si el usuario es idRol = 3, también incluir denominaciones pequeñas
    final moneda50Recibe = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda50RecibeController) : '0';
    final moneda25Recibe = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda25RecibeController) : '0';
    final moneda10Recibe = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda10RecibeController) : '0';
    final moneda5Recibe = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda5RecibeController) : '0';
    final moneda1Recibe = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda1RecibeController) : '0';

    final moneda50Entrega = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda50EntregaController) : '0';
    final moneda25Entrega = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda25EntregaController) : '0';
    final moneda10Entrega = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda10EntregaController) : '0';
    final moneda5Entrega = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda5EntregaController) : '0';
    final moneda1Entrega = mostrarTodasDenominaciones ? getValue(retiroAperturaController.Moneda1EntregaController) : '0';

    // Cálculo del total entregado por el supervisor
    final totalEntrega = (int.parse(billetes10Entrega) * 10) +
        (int.parse(billetes5Entrega) * 5) +
        (int.parse(billetes1Entrega) * 1) +
        (int.parse(moneda50Entrega) * 0.5).toDouble() +
        (int.parse(moneda25Entrega) * 0.25).toDouble() +
        (int.parse(moneda10Entrega) * 0.1).toDouble() +
        (int.parse(moneda5Entrega) * 0.05).toDouble() +
        (int.parse(moneda1Entrega) * 0.01).toDouble();

    // Cálculo del total recibido por el cajero
    final totalRecibe = (int.parse(billetes10Recibe) * 10) +
        (int.parse(billetes20) * 20) +
        (int.parse(billetes5Recibe) * 5) +
        (int.parse(billetes1Recibe) * 1) +
        (int.parse(moneda50Recibe) * 0.5).toDouble() +
        (int.parse(moneda25Recibe) * 0.25).toDouble() +
        (int.parse(moneda10Recibe) * 0.1).toDouble() +
        (int.parse(moneda5Recibe) * 0.05).toDouble() +
        (int.parse(moneda1Recibe) * 0.01).toDouble();

    // **Si los valores no coinciden, mostrar alerta de error**
    if (totalEntrega < totalRecibe) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 10),
                Expanded( // Evita desbordamiento
                  child: Text(
                    "Error en los valores",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Corta el texto si es muy largo
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView( // ⬅ Agregado para evitar overflow
              child: Text(
                "Los valores entregados (\$$totalEntrega) no coinciden con los recibidos (\$$totalRecibe).\n\n"
                    "Por favor, revisa las denominaciones antes de continuar.",
                style: TextStyle(fontSize: 16),
              ),
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
        return SingleChildScrollView(
          child: AlertDialog(
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
                Text("¿Estás seguro de retirar esta apertura?", style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Divider(color: Colors.grey[300]),
                SizedBox(height: 5),

                Text("Recibe de Cajero:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("- $billetes20 billetes de \$20"),
                Text("- $billetes10Recibe billetes de \$10"),
                Text("- $billetes5Recibe billetes de \$5"),
                Text("- $billetes1Recibe monedas de \$1"),
                if (mostrarTodasDenominaciones) ...[
                  Text("- $moneda50Recibe monedas de 50c"),
                  Text("- $moneda25Recibe monedas de 25c"),
                  Text("- $moneda10Recibe monedas de 10c"),
                  Text("- $moneda5Recibe monedas de 5c"),
                  Text("- $moneda1Recibe monedas de 1c"),
                ],
                SizedBox(height: 5),

                Text("Total Recibido: \$${totalRecibe.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),

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

                Text("Total Entregado: \$${totalEntrega.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983))),
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
                onPressed: retiroAperturaController.cargando.value
                    ? null
                    : () async {
                  retiroAperturaController.registarRetiroApertura(context, usuario!, movimiento!);
                },
                child: retiroAperturaController.cargando.value
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text('Confirmar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color(0xFF368983),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}





