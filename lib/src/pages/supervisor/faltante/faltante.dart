import 'package:asistencia_vial_app/src/pages/supervisor/faltante/faltante_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class FaltantesPage extends StatelessWidget {

  late FaltanteController faltanteController;

  Usuario? usuario;
  List<Movimiento>? movimientos;
  int? bandera;

  FaltantesPage({@required this.usuario,@required this.movimientos,@required this.bandera}){
    faltanteController=Get.put(FaltanteController(usuario!,movimientos!,bandera!));
    print('bandera $bandera');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faltantes y Ajustes"),
        backgroundColor: const Color(0xFF368983),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Parte de Trabajo"),
            _buildNumberInputField("Parte de Trabajo", faltanteController.parteTrabajoController),
            const SizedBox(height: 20),
            if (bandera==0) ...[
            ElevatedButton(
              onPressed: () {
                faltanteController.isFaltanteVisible.value =
                !faltanteController.isFaltanteVisible.value;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF368983),
              ),
              child: Obx(() => Text(
                  faltanteController.isFaltanteVisible.value
                      ? "Ocultar Faltantes"
                      : "Agregar Faltantes",style: TextStyle(color: Colors.white),)),
            ),
            const SizedBox(height: 10),
            // Sección de faltantes (Recibido y Entregado)
            Obx(() => Visibility(
              visible: faltanteController.isFaltanteVisible.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Faltante Recibido de cajero"),
                  const SizedBox(height: 8),
                  _recibeGrid(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Cambio entregado"),
                  const SizedBox(height: 8),
                  _entregaGrid(),
                ],
              ),
            )),

            const SizedBox(height: 5),
            _buildSectionTitle("Simulaciones"),
            const SizedBox(height: 8),
            _buildDualInputRow(
              "Cantidad",
              faltanteController.simulacionesCantidadController,
              "Valor (\$)",
              faltanteController.simulacionesValorController,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Anulaciones"),
            const SizedBox(height: 8),
            _buildDualInputRow(
              "Cantidad",
              faltanteController.anulacionesCantidadController,
              "Valor (\$)",
              faltanteController.anulacionesValorController,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Sobrantes"),
            const SizedBox(height: 8),
            _buildNumberInputField("Sobrantes", faltanteController.sobrantesController),
            ],
            SizedBox(height: 30),
            bandera==1?_confirmParteTrabajo(context):
            _confirmButton(context),
            ],

        ),

      ),
    );
  }

  /// **Widget: Título de Sección**
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF368983),
      ),
    );
  }

  /// **Widget: Campo de Entrada Numérica**
  Widget _buildNumberInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF368983)),
        ),
      ),
    );
  }

  /// **Widget: Denominaciones (Recibido/Entregado)**
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
                controller: faltanteController.billetes20ControllerR,
              ),
            ),
            SizedBox(width: 2), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: '\$ 10',
                assetIcon: 'assets/img/billete.png',
                controller: faltanteController.billetes10ControllerR,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: faltanteController.billetes5ControllerR,
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
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.billetes1ControllerR,
              ),
            ),
            SizedBox(width: 2), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: ' 50C',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.Moneda50ControllerR,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 25C',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.Moneda25ControllerR,
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
                controller: faltanteController.Moneda10ControllerR,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 5C',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.Moneda5ControllerR,
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
                controller: faltanteController.billetes10ControllerE,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$ 5',
                assetIcon: 'assets/img/billete.png',
                controller: faltanteController.billetes5ControllerE,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: '\$ 1',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.billetes1ControllerE,
              ),
            ),// Espaciado horizontal entre columnas
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
                controller: faltanteController.Moneda50ControllerE,
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: _inputField(
                label: ' 25C',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.Moneda25ControllerE,
              ),
            ),
            SizedBox(width: 2), // Espaciado horizontal entre columnas
            Expanded(
              child: _inputField(
                label: ' 10C',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.Moneda10ControllerE,
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
                label: ' 5C',
                assetIcon: 'assets/img/moneda.png',
                controller: faltanteController.Moneda5ControllerE,
              ),
            ),

          ],
        ),
      ],
    );
  }

  /// **Widget: Fila Dual de Entrada**
  Widget _buildDualInputRow(
      String label1,
      TextEditingController controller1,
      String label2,
      TextEditingController controller2,
      ) {
    return Row(
      children: [
        Expanded(
          child: _buildNumberInputField(label1, controller1),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildNumberInputField(label2, controller2),
        ),
      ],
    );
  }

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

  /// **Widget: Botón de Confirmación**
  /// **Widget: Botón de Confirmación**
  Widget _confirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Mostrar el resumen de faltantes en un modal
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: confirmFaltante(context),
                    ),
                  );
                },
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF368983),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          bandera==1?
          'Guardar':
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


  /// **Widget: Botón de Confirmación**
  Widget _confirmParteTrabajo(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showParteTrabajoConfirm(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Confirmar Parte de Trabajo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  void _showParteTrabajoConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Guardar"),
          content: Text(
            "${faltanteController.parteTrabajoController.text}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

              },
              child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                faltanteController.actualizarLiquidacion(context, usuario!, movimientos!);
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }


  Widget confirmFaltante(BuildContext context) {
    final double totalFaltantes = _calculateTotalFaltantes();
    final int anulacionesCantidad = int.parse(faltanteController.anulacionesCantidadController.text.isEmpty
        ? '0'
        : faltanteController.anulacionesCantidadController.text);
    final double anulacionesValor = double.parse(faltanteController.anulacionesValorController.text.isEmpty
        ? '0.0'
        : faltanteController.anulacionesValorController.text);
    final int simulacionesCantidad = int.parse(faltanteController.simulacionesCantidadController.text.isEmpty
        ? '0'
        : faltanteController.simulacionesCantidadController.text);
    final double simulacionesValor = double.parse(faltanteController.simulacionesValorController.text.isEmpty
        ? '0.0'
        : faltanteController.simulacionesValorController.text);
    final double sobrantes = double.parse(faltanteController.sobrantesController.text.isEmpty
        ? '0.0'
        : faltanteController.sobrantesController.text);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Resumen de Faltantes y Ajustes"),
          const SizedBox(height: 10),
          _buildSummaryRow("Total Faltantes:", "\$${totalFaltantes.toStringAsFixed(2)}"),
          _buildSummaryRow("Anulaciones:", "$anulacionesCantidad - \$${anulacionesValor.toStringAsFixed(2)}"),
          _buildSummaryRow("Simulaciones:", "$simulacionesCantidad - \$${simulacionesValor.toStringAsFixed(2)}"),
          _buildSummaryRow("Sobrantes:", "\$${sobrantes.toStringAsFixed(2)}"),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                faltanteController.actualizarLiquidacion(context, usuario!, movimientos!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF368983),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Generar Reporte",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Método: Calcular el total de faltantes**
  /// **Método: Calcular el total de faltantes**
  double _calculateTotalFaltantes() {
    // Valores recibidos
    final double recibe20 = double.parse(faltanteController.billetes20ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.billetes20ControllerR.text) * 20;
    final double recibe10 = double.parse(faltanteController.billetes10ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.billetes10ControllerR.text) * 10;
    final double recibe5 = double.parse(faltanteController.billetes5ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.billetes5ControllerR.text) * 5;
    final double recibe1 = double.parse(faltanteController.billetes1ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.billetes1ControllerR.text);
    final double recibe50C = double.parse(faltanteController.Moneda50ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda50ControllerR.text) * 0.50;
    final double recibe25C = double.parse(faltanteController.Moneda25ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda25ControllerR.text) * 0.25;
    final double recibe10C = double.parse(faltanteController.Moneda10ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda10ControllerR.text) * 0.10;
    final double recibe5C = double.parse(faltanteController.Moneda5ControllerR.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda5ControllerR.text) * 0.05;

    final double totalRecibido =
        recibe20 + recibe10 + recibe5 + recibe1 + recibe50C + recibe25C + recibe10C + recibe5C;

    // Valores entregados
    final double entrega10 = double.parse(faltanteController.billetes10ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.billetes10ControllerE.text) * 10;
    final double entrega5 = double.parse(faltanteController.billetes5ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.billetes5ControllerE.text) * 5;
    final double entrega1 = double.parse(faltanteController.billetes1ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.billetes1ControllerE.text);
    final double entrega50C = double.parse(faltanteController.Moneda50ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda50ControllerE.text) * 0.50;
    final double entrega25C = double.parse(faltanteController.Moneda25ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda25ControllerE.text) * 0.25;
    final double entrega10C = double.parse(faltanteController.Moneda10ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda10ControllerE.text) * 0.10;
    final double entrega5C = double.parse(faltanteController.Moneda5ControllerE.text.isEmpty
        ? '0.0'
        : faltanteController.Moneda5ControllerE.text) * 0.05;

    final double totalEntregado =
        entrega10 + entrega5 + entrega1 + entrega50C + entrega25C + entrega10C + entrega5C;

    // Total faltante = Total recibido - Total entregado
    return totalRecibido - totalEntregado;
  }


  /// **Widget: Fila de Resumen**
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }


}

