import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/pdf_liquidacion.dart';
import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/reporte_liquidacion_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class ReporteLiquidacion extends StatelessWidget {

  late ReporteLiquidacionController reporteLiquidacionController;

  Usuario? usuario;
  List<Movimiento>? movimientos;

  ReporteLiquidacion({@required this.movimientos}){
    reporteLiquidacionController=Get.put(ReporteLiquidacionController(movimientos!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          leading: IconButton(
            onPressed: () => Get.offNamedUntil('/home', (route) => false, arguments: {'index': 2}),
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black54,
          ),
          title: const Text('Reporte de Liquidaciones'),
      ),
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: PdfPreview(
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfLiquidacion(movimientos!),
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