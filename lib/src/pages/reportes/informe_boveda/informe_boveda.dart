import 'package:asistencia_vial_app/src/pages/reportes/informe_boveda/informe_boveda_controller.dart';
import 'package:asistencia_vial_app/src/pages/reportes/informe_boveda/pdf_informe.dart';
import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/pdf_liquidacion.dart';
import 'package:asistencia_vial_app/src/pages/reportes/liquidacion_cajero/reporte_liquidacion_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../models/boveda.dart';
import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class InformeBoveda extends StatelessWidget {

  late InformeBovedaController informeBovedaController;

  List<Boveda>? bovedas;
  List<Movimiento>? movimientos;

  InformeBoveda({@required this.bovedas,@required this.movimientos}){
    informeBovedaController=Get.put(InformeBovedaController(bovedas!,movimientos!));
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
        title: const Text('Informe de Bóveda'),
      ),
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: PdfPreview(
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfInformeBoveda(bovedas!,movimientos!),
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