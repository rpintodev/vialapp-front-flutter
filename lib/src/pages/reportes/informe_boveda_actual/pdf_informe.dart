import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:date_format/date_format.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

Future<Uint8List> pdfInformeBovedaActual(List<Boveda> bovedas, List<Movimiento> movimientos) async {
  Usuario usuarioSessio = Usuario.fromJson(GetStorage().read('usuario') ?? {});

  final pdf = pw.Document();

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/img/vial25color.png')).buffer.asUint8List(),
  );

  // Separar movimientos por turnos y tipos
  final ahora = DateTime.now();
  final inicioDiaAnterior = DateTime(ahora.year, ahora.month, ahora.day).subtract(Duration(days: 1));
  final finDiaAnterior = DateTime(ahora.year, ahora.month, ahora.day);
  final aperturas = movimientos.where((m) => m.idTipoMovimiento == '1').toList();
  final liquidaciones = movimientos.where((m) => m.idTipoMovimiento == '4').toList();
  final retirosParciales = movimientos.where((m) => m.idTipoMovimiento == '2').toList();
  final registrosFortius = movimientos.where((m) => m.idTipoMovimiento == '5').toList();
  final boveda=bovedas.where((b) => b.esactual=='1').first;
  final bovedaSecretaria=bovedas.where((b) => b.esactual=='3').first;

  // Calcular los totales solicitados
  final totalAperturas = _calculateTotalAperturas(movimientos);
  final totalRetirosParciales = _calculateTotalRetirosParciales(movimientos);
  final totalLiquidaciones = _calculateTotalLiquidaciones(movimientos);

  final registrosTurno1 = registrosFortius.where((m) => m.turno == '1').toList();
  final registrosTurno3 = registrosFortius.where((m) => m.turno == '3').toList();

  final liquidacionesFiltradas = liquidaciones.where((m) {
    final fechaMovimiento = DateTime.parse(m.fecha ?? '');
    return fechaMovimiento.isAfter(inicioDiaAnterior) && fechaMovimiento.isBefore(finDiaAnterior);
  }).toList();

  final retirosFiltrados = retirosParciales.where((m) {
    final fechaMovimiento = DateTime.parse(m.fecha ?? '');
    return fechaMovimiento.isAfter(inicioDiaAnterior) && fechaMovimiento.isBefore(finDiaAnterior);
  }).toList();


  final horaActual = ahora.hour;

  DateTime horaInicio;
  DateTime horaFin;
  String supervisor1;
  String supervisor2;

  if (horaActual >= 8 && horaActual <= 20) {
    // Entre 5am y

    supervisor1 = registrosTurno1.isNotEmpty
        ? registrosTurno1.first.nombreSupervisor ?? 'Sin Supervisor'
        : '${usuarioSessio.nombre} ${usuarioSessio.apellido}'??'';

    supervisor2 = registrosTurno3.isNotEmpty
        ? registrosTurno3.first.nombreSupervisor ?? 'Sin Supervisor'
        : '${usuarioSessio.nombre} ${usuarioSessio.apellido}'??'';

    horaInicio = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0); // 08:00h
    horaFin = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 0); // 20:00h
  } else {
    // Entre 4pm y 6am
    if (horaActual >= 20) {

      supervisor1 = registrosTurno3.isNotEmpty
          ? registrosTurno3.first.nombreSupervisor ?? 'Sin Supervisor'
          : '${usuarioSessio.nombre} ${usuarioSessio.apellido}'??'';

      supervisor2 = registrosTurno3.isNotEmpty
          ? registrosTurno3.first.nombreSupervisor ?? 'Sin Supervisor'
          : '${usuarioSessio.nombre} ${usuarioSessio.apellido}'??'';

      // Si está entre las 4pm y medianoche
      horaInicio = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 0); // 20:00h
      horaFin = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 8, 0); // 08:00h del día siguiente
    } else {

      supervisor1 = registrosTurno3.isNotEmpty
          ? registrosTurno3.first.nombreSupervisor ?? 'Sin Supervisor'
          : '${usuarioSessio.nombre} ${usuarioSessio.apellido}'??'';

      supervisor2 =  '${usuarioSessio.nombre} ${usuarioSessio.apellido}'??'';
      // Si está entre medianoche y las 6am
      horaInicio = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1, 20, 0); // 20:00h del día anterior
      horaFin = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0); // 08:00h
    }
  }

  // Formatear las horas a "HH:mm"
  String formattedHoraInicio = DateFormat('HH:mm').format(horaInicio);
  String formattedHoraFin = DateFormat('HH:mm').format(horaFin);
  String formattedFechaHoy=DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());



  final totalRecaudacion = _calculateTotalRecaudacion(retirosFiltrados, liquidacionesFiltradas);

  // Crear PDF
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Encabezado
            pw.Row(
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logo, width: 60, height: 40),
                    pw.Text("Peaje ${usuarioSessio.nombrePeaje}", style: pw.TextStyle(fontSize: 10)),
                  ],
                ),pw.SizedBox(width: 80),
                pw.Column(
                  children: [
                pw.Text('INFORME DE BÓVEDA', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text('Actualizado a la fecha: $formattedFechaHoy', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 5),


            // Tabla de denominaciones en bóveda
            pw.SizedBox(height: 5),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {

                1: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.blue100,
                      padding: pw.EdgeInsets.all(3),
                      child: pw.Align(
                          alignment: pw.Alignment.center,

                          child: pw.Text("TOTAL RESERVA EN BÓVEDA", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                      ),

                    ),

                  ],
                ),
              ],
            ),
            _buildBovedaTable(boveda),


            pw.Table(
              columnWidths: {
                1: pw.FlexColumnWidth(3), // Turno
                2: pw.FlexColumnWidth(1), // Responsable
                3: pw.FlexColumnWidth(1), // Total Recaudado
              },
              children: [
                // Cabecera de la tabla
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('TOTAL APERTURAS (+)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${totalAperturas.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),

                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('TOTAL EFECTIVO RESERVA EN BÓVEDA', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${((double.tryParse(boveda.total ?? '0') ?? 0)+totalAperturas).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),

                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('RETIRO PARCIAL (-)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${totalRetirosParciales.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),

                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('LIQUIDACIONES ANTICIPADAS (-)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${totalLiquidaciones.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),

                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('TOTAL EFECTIVO INGRESO DIARIO EN BOVEDA', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${((double.tryParse(boveda.total ?? '0') ?? 0)+totalAperturas-totalLiquidaciones-totalRetirosParciales).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
              ],
            ),



            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {

                1: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.blue100,
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Align(
                          alignment: pw.Alignment.center,

                          child: pw.Text("DEPÓSITOS DEL DIA", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                      ),

                    ),

                  ],
                ),
              ],
            ),
            _buildDepositosDiaTable(registrosFortius),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {

                1: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.blue100,
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Align(
                          alignment: pw.Alignment.center,

                          child: pw.Text("DISPOSITIVOS TAG VENDIDOS", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                      ),

                    ),

                  ],
                ),
              ],
            ),
            _buildBovedaSecretariaTable(bovedaSecretaria),
            pw.Table(
              columnWidths: {
                1: pw.FlexColumnWidth(3), // Turno
                2: pw.FlexColumnWidth(1), // Responsable
                3: pw.FlexColumnWidth(1), // Total Recaudado
              },
              children: [


                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('TOTAL EFECTIVO RECAUDADO DEL DISPOSITIVO TAG', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${((double.tryParse(bovedaSecretaria.total ?? '0') ?? 0)).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue100,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('TOTAL EFECTIVO EN BÓVEDA', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(color: PdfColors.blue100,border: pw.Border.all()),padding: pw.EdgeInsets.all(2),
                      child: pw.Text('\$${((double.tryParse(bovedaSecretaria.total ?? '0') ?? 0)+(double.tryParse(boveda.total ?? '0') ?? 0)+totalAperturas-totalLiquidaciones-totalRetirosParciales).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
              ],
            ),



          ],
        );
      },
    ),
  );

  return pdf.save();
}



/// **Calcular el total de aperturas**
double _calculateTotalAperturas(List<Movimiento> movimientos) {
  return movimientos
      .where((m) => m.idTipoMovimiento == '1') // Filtrar por aperturas
      .fold<double>(
    0,
        (sum, m) => sum +
            (((int.tryParse(m.entrega10D ?? '0') ?? 0) * 10) +
            ((int.tryParse(m.entrega5D ?? '0') ?? 0) * 5) +
             ((int.tryParse(m.entrega1D ?? '0') ?? 0) * 1) +
                 ((int.tryParse(m.entrega50C ?? '0') ?? 0) * 0.5).toDouble() +
                ((int.tryParse(m.entrega25C ?? '0') ?? 0) * 0.25).toDouble() +
                ((int.tryParse(m.entrega10C ?? '0') ?? 0) * 0.1).toDouble() +
                ((int.tryParse(m.entrega5C ?? '0') ?? 0) * 0.05).toDouble()+
                ((int.tryParse(m.entrega1C ?? '0') ?? 0) * 0.01).toDouble())-(
                ((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
                ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
                ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
                ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1)) ,

  );
}

/// **Calcular el total de retiros parciales**
double _calculateTotalRetirosParciales(List<Movimiento> movimientos) {
  return movimientos
      .where((m) => m.idTipoMovimiento == '2') // Filtrar por retiros parciales
      .fold<double>(
    0,
        (sum, m) => sum +
        ((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
        ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
        ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
        ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1),
  );
}

/// **Calcular el total de liquidaciones anticipadas**
double _calculateTotalLiquidaciones(List<Movimiento> movimientos) {
  return movimientos
      .where((m) => m.idTipoMovimiento == '4' || m.idTipoMovimiento=='6') // Filtrar por liquidaciones
      .fold<double>(
    0,
        (sum, m) => sum +
        (((int.tryParse(m.recibe20D ?? '0') ?? 0) *20) +
            ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
            ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
            ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1) +
            ((int.tryParse(m.recibe50C ?? '0') ?? 0) * 0.5).toDouble() +
            ((int.tryParse(m.recibe25C ?? '0') ?? 0) * 0.25).toDouble() +
            ((int.tryParse(m.recibe10C ?? '0') ?? 0) * 0.1).toDouble() +
            ((int.tryParse(m.recibe5C ?? '0') ?? 0) * 0.05).toDouble()+
            ((int.tryParse(m.recibe1C ?? '0') ?? 0) * 0.01).toDouble())  -
        (((int.tryParse(m.entrega10D ?? '0') ?? 0) * 10) +
            ((int.tryParse(m.entrega5D ?? '0') ?? 0) * 5) +
            ((int.tryParse(m.entrega1D ?? '0') ?? 0) * 1)+
            ((int.tryParse(m.entrega50C ?? '0') ?? 0) * 0.5).toDouble()+
            ((int.tryParse(m.entrega25C ?? '0') ?? 0) *0.25).toDouble()+
            ((int.tryParse(m.entrega10C ?? '0') ?? 0) * 0.1).toDouble()+
            ((int.tryParse(m.entrega5C ?? '0') ?? 0) * 0.05).toDouble()
        ),
  );
}


/// **Construir tabla de depósitos del día con total general**
pw.Widget _buildDepositosDiaTable(List<Movimiento> movimientos) {
  // Agrupar por turno
  final turnos = {1, 2, 3};
  double totalGeneral = 0;

  final rows = turnos.map((turno) {
    final registrosTurno = movimientos.where((m) => int.tryParse(m.turno ?? '0') == turno && m.idTipoMovimiento == '5').toList();

    final totalTurno = registrosTurno.fold<double>(
      0,
          (sum, m) => sum +
          (((int.tryParse(m.entrega20D ?? '0') ?? 0) * 20) +
              ((int.tryParse(m.entrega10D ?? '0') ?? 0) * 10) +
              ((int.tryParse(m.entrega5D ?? '0') ?? 0) * 5) +
              ((int.tryParse(m.entrega1D ?? '0') ?? 0) * 1) +
              ((int.tryParse(m.entrega50C ?? '0') ?? 0) * 0.5) +
              ((int.tryParse(m.entrega25C ?? '0') ?? 0) * 0.25) +
              ((int.tryParse(m.entrega10C ?? '0') ?? 0) * 0.1) +
              ((int.tryParse(m.entrega5C ?? '0') ?? 0) * 0.05) +
              ((int.tryParse(m.entrega1C ?? '0') ?? 0) * 0.01)) -
          (((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
              ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
              ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
              ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1) +
              ((int.tryParse(m.recibe50C ?? '0') ?? 0) * 0.5) +
              ((int.tryParse(m.recibe25C ?? '0') ?? 0) * 0.25) +
              ((int.tryParse(m.recibe10C ?? '0') ?? 0) * 0.1) +
              ((int.tryParse(m.recibe5C ?? '0') ?? 0) * 0.05) +
              ((int.tryParse(m.recibe1C ?? '0') ?? 0) * 0.01)),
    );

    totalGeneral += totalTurno; // Sumar al total general

    final responsable = registrosTurno.isNotEmpty ? registrosTurno.first.nombreSupervisor ?? '' : 'N/A';

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(2),
          child: pw.Text('Turno $turno', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(2),
          child: pw.Text(responsable, style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(2),
          child: pw.Text('\$${totalTurno.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }).toList();

  // Agregar fila con el total de los 3 turnos
  final totalRow = pw.TableRow(
    decoration: pw.BoxDecoration(color: PdfColors.grey300),
    children: [

      pw.Padding(
        padding: pw.EdgeInsets.all(2),
        child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(2),
        child: pw.Text('Total General', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(2),
        child: pw.Text('\$${totalGeneral.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
      ),
    ],
  );

  return pw.Table(
    border: pw.TableBorder.all(),
    columnWidths: {
      0: pw.FlexColumnWidth(2), // Turno
      1: pw.FlexColumnWidth(4), // Responsable
      2: pw.FlexColumnWidth(2), // Total
    },
    children: [
      // Cabecera de la tabla
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.blue50),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Turno', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Responsable', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Valor (\$)', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
        ],
      ),
      ...rows,
      totalRow, // Agregar la fila del total general
    ],
  );
}


/// Construir tabla de denominaciones en bóveda con "Total Billetes" y "Total Monedas"
pw.Widget _buildBovedaTable(Boveda boveda) {
  final denominaciones = [
    {'tipo': 'Billete', 'denominacion': '\$20', 'cantidad': boveda.billete20, 'valor': ((double.tryParse(boveda.billete20 ?? '0') ?? 0) * 20)},
    {'tipo': 'Billete', 'denominacion': '\$10', 'cantidad': boveda.billete10, 'valor': ((double.tryParse(boveda.billete10 ?? '0') ?? 0) * 10)},
    {'tipo': 'Billete', 'denominacion': '\$5', 'cantidad': boveda.billete5, 'valor': ((double.tryParse(boveda.billete5 ?? '0') ?? 0) * 5)},
    {'tipo': 'Billete', 'denominacion': '\$1', 'cantidad': boveda.billete1, 'valor': ((double.tryParse(boveda.billete1 ?? '0') ?? 0) * 1)},
    {'tipo': 'Billete', 'denominacion': '\$2', 'cantidad': boveda.billete2, 'valor': ((double.tryParse(boveda.billete2 ?? '0') ?? 0) * 2)},
    {'tipo': 'Moneda', 'denominacion': '\$1', 'cantidad': boveda.moneda1, 'valor': ((double.tryParse(boveda.moneda1 ?? '0') ?? 0) * 1)},
    {'tipo': 'Moneda', 'denominacion': '50¢', 'cantidad': boveda.moneda05, 'valor': ((double.tryParse(boveda.moneda05 ?? '0') ?? 0) * 0.5)},
    {'tipo': 'Moneda', 'denominacion': '25¢', 'cantidad': boveda.moneda025, 'valor': ((double.tryParse(boveda.moneda025 ?? '0') ?? 0) * 0.25)},
    {'tipo': 'Moneda', 'denominacion': '10¢', 'cantidad': boveda.moneda01, 'valor': ((double.tryParse(boveda.moneda01 ?? '0') ?? 0) * 0.1)},
    {'tipo': 'Moneda', 'denominacion': '5¢', 'cantidad': boveda.moneda005, 'valor': ((double.tryParse(boveda.moneda005 ?? '0') ?? 0) * 0.05)},
    {'tipo': 'Moneda', 'denominacion': '1¢', 'cantidad': boveda.moneda001, 'valor': ((double.tryParse(boveda.moneda001 ?? '0') ?? 0) * 0.01)},
  ];

  // Separar denominaciones en billetes y monedas
  final billetes = denominaciones.where((den) => den['tipo'] == 'Billete').toList();
  final monedas = denominaciones.where((den) => den['tipo'] == 'Moneda').toList();

  // Calcular totales
  final totalBilletes = billetes.fold(0.0, (sum, den) => sum + (den['valor'] as double));
  final totalMonedas = monedas.fold(0.0, (sum, den) => sum + (den['valor'] as double));

  return pw.Table(
    border: pw.TableBorder.all(),
    columnWidths: {
      0: pw.FlexColumnWidth(1),
      1: pw.FlexColumnWidth(1),
      2: pw.FlexColumnWidth(1),
      3: pw.FlexColumnWidth(1),
    },
    children: [
      // Cabecera de la tabla
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.blue50),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Tipo', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Denominación', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Cantidad', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Valor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
        ],
      ),
      // Filas de billetes
      ...billetes.map((den) {
        return pw.TableRow(
          children: [
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['tipo'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['denominacion'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('${den['cantidad'] ?? 0}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${(den['valor'] as double).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          ],
        );
      }).toList(),
      // Fila de total billetes
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Total Billetes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${totalBilletes.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
        ],
      ),
      // Filas de monedas
      ...monedas.map((den) {
        return pw.TableRow(
          children: [
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['tipo'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['denominacion'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('${den['cantidad'] ?? 0}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${(den['valor'] as double).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          ],
        );
      }).toList(),
      // Fila de total monedas
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Total Monedas', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${totalMonedas.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
        ],
      ),
    ],
  );
}


/// Construir tabla de denominaciones en bóveda con "Total Billetes" y "Total Monedas"
pw.Widget _buildBovedaSecretariaTable(Boveda boveda) {
  final denominaciones = [
    {'tipo': 'Billete', 'denominacion': '\$20', 'cantidad': boveda.billete20, 'valor': ((double.tryParse(boveda.billete20 ?? '0') ?? 0) * 20)},
    {'tipo': 'Billete', 'denominacion': '\$10', 'cantidad': boveda.billete10, 'valor': ((double.tryParse(boveda.billete10 ?? '0') ?? 0) * 10)},
    {'tipo': 'Billete', 'denominacion': '\$5', 'cantidad': boveda.billete5, 'valor': ((double.tryParse(boveda.billete5 ?? '0') ?? 0) * 5)},
    {'tipo': 'Billete', 'denominacion': '\$1', 'cantidad': boveda.billete1, 'valor': ((double.tryParse(boveda.billete1 ?? '0') ?? 0) * 1)},
    {'tipo': 'Billete', 'denominacion': '\$2', 'cantidad': boveda.billete2, 'valor': ((double.tryParse(boveda.billete2 ?? '0') ?? 0) * 2)},
    {'tipo': 'Moneda', 'denominacion': '\$1', 'cantidad': boveda.moneda1, 'valor': ((double.tryParse(boveda.moneda1 ?? '0') ?? 0) * 1)},
    {'tipo': 'Moneda', 'denominacion': '50¢', 'cantidad': boveda.moneda05, 'valor': ((double.tryParse(boveda.moneda05 ?? '0') ?? 0) * 0.5)},
    {'tipo': 'Moneda', 'denominacion': '25¢', 'cantidad': boveda.moneda025, 'valor': ((double.tryParse(boveda.moneda025 ?? '0') ?? 0) * 0.25)},
    {'tipo': 'Moneda', 'denominacion': '10¢', 'cantidad': boveda.moneda01, 'valor': ((double.tryParse(boveda.moneda01 ?? '0') ?? 0) * 0.1)},
    {'tipo': 'Moneda', 'denominacion': '5¢', 'cantidad': boveda.moneda005, 'valor': ((double.tryParse(boveda.moneda005 ?? '0') ?? 0) * 0.05)},
    {'tipo': 'Moneda', 'denominacion': '1¢', 'cantidad': boveda.moneda001, 'valor': ((double.tryParse(boveda.moneda001 ?? '0') ?? 0) * 0.01)},
  ];

  // Separar denominaciones en billetes y monedas
  final billetes = denominaciones.where((den) => den['tipo'] == 'Billete').toList();
  final monedas = denominaciones.where((den) => den['tipo'] == 'Moneda').toList();

  // Calcular totales
  final totalBilletes = billetes.fold(0.0, (sum, den) => sum + (den['valor'] as double));
  final totalMonedas = monedas.fold(0.0, (sum, den) => sum + (den['valor'] as double));

  return pw.Table(
    border: pw.TableBorder.all(),
    columnWidths: {
      0: pw.FlexColumnWidth(1),
      1: pw.FlexColumnWidth(1),
      2: pw.FlexColumnWidth(1),
      3: pw.FlexColumnWidth(1),
    },
    children: [
      // Cabecera de la tabla
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.blue50),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Tipo', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Denominación', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Cantidad', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Valor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
        ],
      ),
      // Filas de billetes
      ...billetes.map((den) {
        return pw.TableRow(
          children: [
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['tipo'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['denominacion'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('${den['cantidad'] ?? 0}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${(den['valor'] as double).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          ],
        );
      }).toList(),
      // Fila de total billetes
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Total Billetes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${totalBilletes.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
        ],
      ),
      // Filas de monedas
      ...monedas.map((den) {
        return pw.TableRow(
          children: [
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['tipo'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(den['denominacion'].toString(), style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('${den['cantidad'] ?? 0}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${(den['valor'] as double).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          ],
        );
      }).toList(),
      // Fila de total monedas
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('Total Monedas', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text('\$${totalMonedas.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center)),
        ],
      ),
    ],
  );
}




double _calculateTotalRecaudacion(List<Movimiento> movimientos, List<Movimiento> liquidaciones) {
  final totalMovimientos = movimientos.fold<int>(
    0,
        (sum, m) =>
    sum +
        ((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
        ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
        ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5),
  );

  final totalLiquidaciones = liquidaciones.fold<double>(
    0,
        (sum, m) =>
    sum +
        ((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
        ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
        ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
        ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1)+
        ((int.tryParse(m.recibe1DB ?? '0') ?? 0) * 1)+
        ((int.tryParse(m.recibe2D ?? '0') ?? 0) * 2)+
        ((int.tryParse(m.recibe50C ?? '0') ?? 0) * 0.5)+
        ((int.tryParse(m.recibe25C ?? '0') ?? 0) * 0.25)+
        ((int.tryParse(m.recibe10C ?? '0') ?? 0) * 0.1)+
        ((int.tryParse(m.recibe5C ?? '0') ?? 0) * 0.05)+
        ((int.tryParse(m.recibe1C ?? '0') ?? 0) * 0.01),
  );

  return totalMovimientos + totalLiquidaciones;
}



Future<pw.MemoryImage?> fetchSignature(String? url) async {
  if (url == null || url.isEmpty) return null;

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    }
  } catch (e) {
    print("Error fetching signature: $e");
  }

  return null;
}

