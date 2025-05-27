import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/pdf_liquidacion.dart';
import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/reporte_liquidacion_controller.dart';
import 'package:asistencia_vial_app/src/pages/reportes/recaudaciones_parciales/pdf_recaudaciones.dart';
import 'package:asistencia_vial_app/src/pages/reportes/recaudaciones_parciales/reporte_recaudaciones_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class ReporteRecaudaciones extends StatelessWidget {

  late ReporteRecaudacionesController reporteRecaudacionesController;

  Usuario? usuario;
  List<Movimiento>? movimientos;

  ReporteRecaudaciones({@required this.usuario,@required this.movimientos}){
    reporteRecaudacionesController=Get.put(ReporteRecaudacionesController(usuario!,movimientos!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          onPressed: () => Get.offNamedUntil('/home', (route) => false, arguments: {'index': 0}),
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black54,
        ),
        title: const Text('Reporte de Recaudaciones'),
        actions: [
          // Botón para guardar en el servidor
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              // Generar el PDF usando tu función existente
              final pdfBytes = await pdfRecaudaciones(usuario!,movimientos!);

              // Enviar los bytes al controlador
              reporteRecaudacionesController.guardarPDFEnServidor(pdfBytes);
            },
            tooltip: 'Guardar en servidor',
          ),
        ],
      ),
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: PdfPreview(
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfRecaudaciones(usuario!,movimientos!),
        ),
      ),

    );
  }


  Widget _buttonBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios), color: Colors.white),
      ),
    );
  }
}