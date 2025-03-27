import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/pdf_liquidacion.dart';
import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/reporte_liquidacion_controller.dart';
import 'package:asistencia_vial_app/src/pages/reportes/reporte_canje/pdf_canje.dart';
import 'package:asistencia_vial_app/src/pages/reportes/reporte_canje/reporte_canje_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class ReporteCanje extends StatelessWidget {

  late ReporteCanjeController reporteCanjeController;

  Usuario? usuario;
  List<Movimiento>? movimientos;

  ReporteCanje({@required this.usuario,@required this.movimientos}){
    reporteCanjeController=Get.put(ReporteCanjeController(usuario!,movimientos!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          onPressed: () => Get.offNamedUntil('/home', (route) => false, arguments: {'index': 1}),
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black54,
        ),
        title: const Text('Reporte de Canje'),
      ),
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: PdfPreview(
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfCaje(usuario!,movimientos!),
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