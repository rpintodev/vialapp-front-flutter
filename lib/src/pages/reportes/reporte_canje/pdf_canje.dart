import 'package:date_format/date_format.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

Future<Uint8List> pdfCaje(Usuario usuario, List<Movimiento> movimientos) async {
  final pdf = pw.Document();

  final liquidacion = movimientos.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());
  final retirosParciales = movimientos.where((m) => m.idTipoMovimiento == '2').toList();
  final fecha = formatDate(DateTime.parse(retirosParciales.last.fecha??'0'), [dd, '/', mm, '/', yyyy,]);

  final int totalCanjes = movimientos.where((m) => m.idTipoMovimiento == '3').length;
  final int totalRetiros = movimientos.where((m) => m.idTipoMovimiento == '2').length;

  final totalLiquidacion = ((int.tryParse(liquidacion.recibe20D ?? '0') ?? 0) * 20) +
      ((int.tryParse(liquidacion.recibe10D ?? '0') ?? 0) * 10) + ((int.tryParse(liquidacion.recibe5D ?? '0') ?? 0) * 5) +
      ((int.tryParse(liquidacion.recibe1D ?? '0') ?? 0) * 1)+((int.tryParse(liquidacion.recibe1DB ?? '0') ?? 0) * 1)+((int.tryParse(liquidacion.recibe2D ?? '0') ?? 0) * 2)+((int.tryParse(liquidacion.recibe50C ?? '0') ?? 0) * 0.5)+
      ((int.tryParse(liquidacion.recibe25C ?? '0') ?? 0) * 0.25)+((int.tryParse(liquidacion.recibe10C ?? '0') ?? 0) * 0.1)+
      ((int.tryParse(liquidacion.recibe5C ?? '0') ?? 0) * 0.05)+((int.tryParse(liquidacion.recibe1C ?? '0') ?? 0) * 0.01);

  final double totalApertura = movimientos
      .where((m) => m.idTipoMovimiento == '1')
      .fold(0.0, (sum, m) => sum +
      (int.tryParse(m.recibe20D ?? '0') ?? 0) * 20 +
      (int.tryParse(m.recibe10D ?? '0') ?? 0) * 10 +
      (int.tryParse(m.recibe5D ?? '0') ?? 0) * 5 +
      (int.tryParse(m.recibe1D ?? '0') ?? 0) * 1);

  // Definir denominaciones
  final Map<String, String> denominacionesMap = {
    "\$20": "20d",
    "\$10": "10d",
    "\$5": "5d",
    "\$1": "1d",
    "\$0.5": "50c",
    "\$0.25": "25c",
    "\$0.1": "10c",
    "\$0.05": "5c",
    "\$0.01": "1c"
  };

  // Obtener la cantidad total de cada denominación
  int obtenerCantidad(List<Movimiento> movimientos, String tipo, String denominacion) {
    return movimientos.fold(0, (total, movimiento) {
      return total + (int.tryParse(movimiento.toJson()["${tipo}_${denominacion}"] ?? '0') ?? 0);
    });
  }



// Calcular cantidades y valores
  final List<int> cantidadesRecaudadas = denominacionesMap.entries.map((entry) {
    return obtenerCantidad([liquidacion], "Recibe", entry.value);
  }).toList();

  final List<int> cantidadesCanjeEgreso = denominacionesMap.entries.map((entry) {
    return obtenerCantidad(movimientos.where((m) => m.idTipoMovimiento == '3' || m.idTipoMovimiento == '1').toList(), "Entrega", entry.value);
  }).toList();

  final List<int> cantidadesCanjeIngreso = denominacionesMap.entries.map((entry) {
    return obtenerCantidad(movimientos.where((m) => m.idTipoMovimiento == '3' || m.idTipoMovimiento == '1' || m.idTipoMovimiento == '2').toList(), "Recibe", entry.value);
  }).toList();

// Calcular valores monetarios
  final List<double> valoresRecaudados = List.generate(denominacionesMap.length, (i) => cantidadesRecaudadas[i] * double.parse(denominacionesMap.keys.elementAt(i).replaceAll("\$", "")));
  final List<double> valoresCanjeEgreso = List.generate(denominacionesMap.length, (i) => cantidadesCanjeEgreso[i] * double.parse(denominacionesMap.keys.elementAt(i).replaceAll("\$", "")));
  final List<int> cantidadesRecolectadas = List.generate(denominacionesMap.length, (i) => cantidadesRecaudadas[i] - cantidadesCanjeEgreso[i]);
  final List<double> valoresRecolectados = List.generate(denominacionesMap.length, (i) => valoresRecaudados[i] - valoresCanjeEgreso[i]);
  final List<double> valoresCanjeIngreso = List.generate(denominacionesMap.length, (i) => cantidadesCanjeIngreso[i] * double.parse(denominacionesMap.keys.elementAt(i).replaceAll("\$", "")));




  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/img/vial25color.png')).buffer.asUint8List(),
  );

  pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(logo, width: 60, height: 40),
                        pw.Text("Peaje ${liquidacion.idPeaje == null ? 'Desconocido' : (liquidacion.idPeaje == '1' ? 'Congoma' : 'Los Angeles')}", style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),pw.SizedBox(width: 100),
                    pw.Text('REPORTE DE ANÁLISIS DE CANJES', style: pw.TextStyle(fontSize: 14), textAlign: pw.TextAlign.center),

                  ],
                ),
                pw.SizedBox(height: 10),

                // Tablas de la parte superior
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // Primera columna
                    1: pw.FlexColumnWidth(2), // Segunda columna
                    2: pw.FlexColumnWidth(1), // Tercera columna
                    3: pw.FlexColumnWidth(2), // Cuarta columna
                  },
                  children: [

                    // Fila 1
                    pw.TableRow(children: [

                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3),child: pw.Text("Nombre Cajero", style: pw.TextStyle(fontSize: 8)),),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(movimientos.first.nombreCajero??'', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Nombre Supervisor", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(retirosParciales.last.nombreSupervisor??'', style: pw.TextStyle(fontSize: 8))),
                    ]),
                    // Fila 2
                    pw.TableRow(children: [
                      pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border(bottom: pw.BorderSide.none)),padding: pw.EdgeInsets.all(3), child: pw.Text("Turno", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(liquidacion.turno??'', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Fecha", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(fecha, style: pw.TextStyle(fontSize: 8))),
                    ]),

                  ],
                ),

                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // Primera columna
                    1: pw.FlexColumnWidth(2), // Segunda columna
                    2: pw.FlexColumnWidth(1), // Tercera columna
                    3: pw.FlexColumnWidth(2), // Cuarta columna
                  },
                  children: [

                    // Fila 1
                    pw.TableRow(children: [
                      pw.Container(
                        decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(3),child: pw.Text("Via", style: pw.TextStyle(fontSize: 8)),),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(liquidacion.via??'', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(),
                      pw.Container(),
                    ]),

                  ],
                ),
                pw.SizedBox(height: 20),

                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // Denominación
                    1: pw.FlexColumnWidth(1), // Cantidad Recaudado
                    2: pw.FlexColumnWidth(1), // Valor Recaudado
                    3: pw.FlexColumnWidth(1), // Canje Interno Egreso
                    4: pw.FlexColumnWidth(1), // Canje Interno Ingreso
                    5: pw.FlexColumnWidth(1), // Cantidad Recolectado
                    6: pw.FlexColumnWidth(1), // Valor Recolectado
                    7: pw.FlexColumnWidth(1), // Valor Canje Interno Ingreso
                  },
                  children: [
                    // Cabecera
                    pw.TableRow(
                      children: [
                        pw.Container(
                       padding: pw.EdgeInsets.all(2), child: pw.Text("Denominación", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Container(
                        decoration: pw.BoxDecoration(color: PdfColors.green200),padding: pw.EdgeInsets.all(2), child: pw.Text("Cantidad Recaudado (a)", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.green200),padding: pw.EdgeInsets.all(2), child: pw.Text("Valor Recaudado", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.orange200),padding: pw.EdgeInsets.all(2), child: pw.Text("Canje Interno Egreso (b)", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.orange200),padding: pw.EdgeInsets.all(7), child: pw.Text("Valor", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text("Recolectado (a-b)", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.blue200),padding: pw.EdgeInsets.all(2), child: pw.Text("Caneje Interno Ingreso", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.blue200),padding: pw.EdgeInsets.all(7), child: pw.Text("Total", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                      ],
                    ),

                    // Filas de valores
                    ...List.generate(denominacionesMap.length, (i) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(denominacionesMap.keys.elementAt(i), style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                          pw.Container(
                              decoration: pw.BoxDecoration(color: PdfColors.green50),padding: pw.EdgeInsets.all(4), child: pw.Text(cantidadesRecaudadas[i].toString(), style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                          pw.Container(
                              decoration: pw.BoxDecoration(color: PdfColors.green50),padding: pw.EdgeInsets.all(4), child: pw.Text("\$${valoresRecaudados[i].toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                          pw.Container(
                              decoration: pw.BoxDecoration(color: PdfColors.orange50),padding: pw.EdgeInsets.all(4), child: pw.Text(cantidadesCanjeEgreso[i].toString(), style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                          pw.Container(
                              decoration: pw.BoxDecoration(color: PdfColors.orange50),padding: pw.EdgeInsets.all(4), child: pw.Text("\$${valoresCanjeEgreso[i].toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(cantidadesRecolectadas[i].toString(), style: pw.TextStyle(fontSize: 10,color: cantidadesRecolectadas[i] < 0 ? PdfColors.red900 : PdfColors.black ), textAlign: pw.TextAlign.center)),
                          pw.Container(
                              decoration: pw.BoxDecoration(color: PdfColors.blue50),padding: pw.EdgeInsets.all(4), child: pw.Text(cantidadesCanjeIngreso[i].toString(), style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                          pw.Container(
                              decoration: pw.BoxDecoration(color: PdfColors.blue50),padding: pw.EdgeInsets.all(4), child: pw.Text("\$${valoresCanjeIngreso[i].toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                        ],
                      );
                    }),
                  ],
                ),

                pw.SizedBox(height: 20),


                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(3), // Tipo de movimiento
                    1: pw.FlexColumnWidth(1), // Cantidad / Total
                  },
                  children: [
                    // Cabecera
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50),
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("Resumen de Movimientos",
                                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("Valor",
                                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center)),
                      ],
                    ),

                    pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("Valor total de la Apertura",
                                style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("\$${totalApertura.toStringAsFixed(2)}",
                                style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    // Fila: Canjes realizados
                    pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("Cantidad de Canjes realizados",
                                style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(totalCanjes.toString(),
                                style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                      ],
                    ),

                    // Fila: Valor total de la Apertura


                    // Fila: Cantidad de Retiros Parciales
                    pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("Cantidad de Retiros Parciales",
                                style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(totalRetiros.toString(),
                                style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                      ],
                    ),

                    // Fila: Total de la Liquidación
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("Total de la Liquidación",
                                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text("\$${totalLiquidacion.toStringAsFixed(2)}",
                                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center)),
                      ],
                    ),
                  ],
                ),
              ],
          );
        }
      )
  );
        return pdf.save();
}
