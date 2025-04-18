import 'package:date_format/date_format.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

Future<Uint8List> pdfLiquidacion(List<Movimiento> movimientos) async {
  final pdf = pw.Document();

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/img/vial25color.png')).buffer.asUint8List(),
  );

  // Filtrar retiros parciales
  final retirosParciales = movimientos.where((m) => m.idTipoMovimiento == '2').toList();
  retirosParciales.sort((a, b) => a.fecha!.compareTo(b.fecha!));

  final apertura = movimientos.firstWhere((m) => m.idTipoMovimiento == '1', orElse: () => Movimiento());

  final canjes = movimientos.where((m) => m.idTipoMovimiento == '3').toList();
  if (canjes.length <= 1) {
    final canjes=[];
  }

  final primerCanje = movimientos.firstWhere((m) => m.idTipoMovimiento == '3',orElse: () => Movimiento());


  // Detalle de la última entrega de valores
  final liquidacion = movimientos.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());


  final faltantes = movimientos.firstWhere((m) => m.idTipoMovimiento == '6', orElse: () => Movimiento());

  final totalParciales = retirosParciales.fold<double>(0, (sum, mov) => sum + ((int.tryParse(mov.recibe20D ?? '0') ?? 0) * 20) +
      ((int.tryParse(mov.recibe10D ?? '0') ?? 0) * 10) +
      ((int.tryParse(mov.recibe5D ?? '0') ?? 0) * 5) +
      ((int.tryParse(mov.recibe1D ?? '0') ?? 0) * 1));

  final totalLiquidacion = ((int.tryParse(liquidacion.recibe20D ?? '0') ?? 0) * 20) +
      ((int.tryParse(liquidacion.recibe10D ?? '0') ?? 0) * 10) + ((int.tryParse(liquidacion.recibe5D ?? '0') ?? 0) * 5) +
      ((int.tryParse(liquidacion.recibe1D ?? '0') ?? 0) * 1)+((int.tryParse(liquidacion.recibe1DB ?? '0') ?? 0) * 1)+((int.tryParse(liquidacion.recibe2D ?? '0') ?? 0) * 2)+((int.tryParse(liquidacion.recibe50C ?? '0') ?? 0) * 0.5)+
      ((int.tryParse(liquidacion.recibe25C ?? '0') ?? 0) * 0.25)+((int.tryParse(liquidacion.recibe10C ?? '0') ?? 0) * 0.1)+
      ((int.tryParse(liquidacion.recibe5C ?? '0') ?? 0) * 0.05)+((int.tryParse(liquidacion.recibe1C ?? '0') ?? 0) * 0.01);

  final totalApertura = ((int.tryParse(apertura.entrega10D ?? '0') ?? 0) * 10) +
      ((int.tryParse(apertura.entrega5D ?? '0') ?? 0) * 5) +
      ((int.tryParse(apertura.entrega1D ?? '0') ?? 0) * 1);

  final totalPrimerCanje = ((int.tryParse(primerCanje.entrega10D ?? '0') ?? 0) * 10) +
      ((int.tryParse(primerCanje.entrega5D ?? '0') ?? 0) * 5) +
      ((int.tryParse(primerCanje.entrega1D ?? '0') ?? 0) * 1);


  final totalRecibido =
      ((int.tryParse(faltantes.recibe20D ?? '0') ?? 0) * 20) +
          ((int.tryParse(faltantes.recibe10D ?? '0') ?? 0) * 10) +
          ((int.tryParse(faltantes.recibe5D ?? '0') ?? 0) * 5) +
          ((int.tryParse(faltantes.recibe1D ?? '0') ?? 0) * 1) +
          ((int.tryParse(faltantes.recibe50C ?? '0') ?? 0) * 0.5) +
          ((int.tryParse(faltantes.recibe25C ?? '0') ?? 0) * 0.25) +
          ((int.tryParse(faltantes.recibe10C ?? '0') ?? 0) * 0.1) +
          ((int.tryParse(faltantes.recibe5C ?? '0') ?? 0) * 0.05);

// Calcular el total entregado
  final totalEntregado =
      ((int.tryParse(faltantes.entrega10D ?? '0') ?? 0) * 10) +
          ((int.tryParse(faltantes.entrega5D ?? '0') ?? 0) * 5) +
          ((int.tryParse(faltantes.entrega1D ?? '0') ?? 0) * 1) +
          ((int.tryParse(faltantes.entrega50C ?? '0') ?? 0) * 0.5) +
          ((int.tryParse(faltantes.entrega25C ?? '0') ?? 0) * 0.25) +
          ((int.tryParse(faltantes.entrega10C ?? '0') ?? 0) * 0.1) +
          ((int.tryParse(faltantes.entrega5C ?? '0') ?? 0) * 0.05);

// Total faltante = Total recibido - Total entregado
  final totalFaltantes = totalRecibido - totalEntregado;
  pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header: Logo y nombre del peaje
                pw.Row(
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(logo, width: 60, height: 40),
                        pw.Text("Peaje ${liquidacion.idPeaje == null ? 'Desconocido' : (liquidacion.idPeaje == '1' ? 'Congoma' : 'Los Angeles')}", style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),pw.SizedBox(width: 50),
                    pw.Text('COMPROBANTE DE APERTURA, RENDICIÓN DE CAJA Y \n REGISTRO DE INCIDENCIAS', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),

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

                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3),child: pw.Text("Fecha", style: pw.TextStyle(fontSize: 8)),),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(formatDate(DateTime.parse(apertura.fecha??'0'), [dd, '/', mm, '/', yyyy,]), style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Guía de Remisión", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(apertura.idturno??'', style: pw.TextStyle(fontSize: 8))),
                    ]),
                    // Fila 2
                    pw.TableRow(children: [
                      pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border(bottom: pw.BorderSide.none)),padding: pw.EdgeInsets.all(3), child: pw.Text("Turno", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(apertura.turno??'', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Parte de Trabajo", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(liquidacion.partetrabajo??'', style: pw.TextStyle(fontSize: 8))),
                    ]),
                    // Fila 3
                    pw.TableRow(children: [
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Vía", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(apertura.via??'Via no asignada', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Nombre del Cajero", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(movimientos.first.nombreCajero ?? "No registrado", style: pw.TextStyle(fontSize: 8))),
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
                        decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(3),child: pw.Text("Apertura", style: pw.TextStyle(fontSize: 8)),),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text('\$ ${totalApertura}', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(),
                      pw.Container(),
                    ]),

                  ],
                ),


                // pw. Table

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

                              child: pw.Text("RECAUDACIONES PARCIALES", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                          ),

                        ),

                      ],
                    ),
                  ],
                ),
                pw.Table(
                  border: pw.TableBorder.all(), // Bordes externos para toda la tabla

                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(2),
                    4: pw.FlexColumnWidth(3),
                  },
                  children: [
                    // Cabecera
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50),
                      children: [
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("N° Retiro", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Hora", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("USD", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Supervisor", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("Denominación", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    // Filas dinámicas
                    ...retirosParciales.map((r) {

                      final horaRetirosPraciales = formatDate(DateTime.parse(r.fecha??'0'), [HH, ':', nn]);

                      double totalDenominacionesR = ((int.tryParse(r.recibe20D ?? '0') ?? 0) * 20) +
                          ((int.tryParse(r.recibe10D ?? '0') ?? 0) * 10) +
                          ((int.tryParse(r.recibe5D ?? '0') ?? 0) * 5) +
                          ((int.tryParse(r.recibe1D ?? '0') ?? 0) * 1);
                      String observaciones = "";
                      if ((int.tryParse(r.recibe20D ?? '0') ?? 0) > 0) {
                        observaciones += "\$20x${r.recibe20D} ";
                      }
                      if ((int.tryParse(r.recibe10D ?? '0') ?? 0) > 0) {
                        observaciones += "\$10x${r.recibe10D} ";
                      }
                      if ((int.tryParse(r.recibe5D ?? '0') ?? 0) > 0) {
                        observaciones += "\$5x${r.recibe5D} ";
                      }
                      if ((int.tryParse(r.recibe1D ?? '0') ?? 0) > 0) {
                        observaciones += "\$1x${r.recibe1D} ";
                      }

                      observaciones = observaciones.trim();
                      return pw.TableRow(children: [
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text("${retirosParciales.indexOf(r) + 1}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(horaRetirosPraciales ?? "No registrado", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text("\$${totalDenominacionesR.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(r.nombreSupervisor ?? "No registrado", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(observaciones.isNotEmpty ? observaciones : "N/A", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ]);
                    }).toList(),
                    // Fila final con Total

                  ],
                ),
                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // La primera columna ocupará la mitad del espacio
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(2),
                    4: pw.FlexColumnWidth(3),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(),
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Expanded(
                            flex: 3, // Combina la primera y segunda columna
                            child: pw.Text("TOTAL", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                          ),
                        ),

                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text("\$${retirosParciales.fold<double>(0, (sum, r) {
                            double totalR = ((int.tryParse(r.recibe20D ?? '0') ?? 0) * 20) +
                                ((int.tryParse(r.recibe10D ?? '0') ?? 0) * 10) +
                                ((int.tryParse(r.recibe5D ?? '0') ?? 0) * 5) +
                                ((int.tryParse(r.recibe1D ?? '0') ?? 0) * 1);
                            return sum + totalR;
                          }).toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child:  pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border(bottom: pw.BorderSide.none))),

                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.SizedBox(), // Quinta columna vacía
                        ),
                        pw.Container(),
                        pw.Container(),
                      ],
                    ),
                  ],
                ),


                // Detalle de la última entrega de valores
                pw.SizedBox(height: 5),
                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1.7), // La primera columna ocupará la mitad del espacio
                    1: pw.FlexColumnWidth(1), // La segunda columna ocupará la otra mitad
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue100,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Align(
                              alignment: pw.Alignment.center,

                              child: pw.Text("DETALLE DE LA ULTIMA ENTREGA DE VALORES", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                          ),

                        ),
                        pw.Container(),

                      ],
                    ),
                  ],
                ),
                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(0.8), // Reduce el ancho de las columnas originales
                    1: pw.FlexColumnWidth(0.8),
                    2: pw.FlexColumnWidth(0.8),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1),
                    5: pw.FlexColumnWidth(1), // Nuevas columnas sin datos
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Tipo", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Denominación", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Cantidad", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Valor", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(),
                        pw.Container(),
                      ],
                    ),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Moneda", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("0,01 C", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe1C ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe1C ?? "0") * 0.01}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Moneda", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("0,05 C", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe5C ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe5C ?? "0") * 0.05}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Moneda", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("0,10 C", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe10C ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe10C ?? "0") * 0.1}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Moneda", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("0,25 C", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe25C ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe25C ?? "0") * 0.25}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Moneda", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("0,50 C", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe50C ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe50C ?? "0") * 0.5}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Moneda", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ 1", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe1D ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe1D ?? "0") * 1}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Billete", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ 1", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe1DB ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe1DB ?? "0") * 1}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Billete", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ 2", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe2D ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe2D ?? "0") * 2}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Billete", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ 5", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe5D ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe5D ?? "0") * 5}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Billete", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ 10", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe10D ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe10D ?? "0") * 10}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Billete", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ 20", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text(liquidacion.recibe20D ?? "0", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("\$ ${int.parse(liquidacion.recibe20D ?? "0") * 20}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                  ],
                ),
                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1.08), // La primera columna ocupará la mitad del espacio
                    1: pw.FlexColumnWidth(0.45),
                    2: pw.FlexColumnWidth(0.9),// La segunda columna ocupará la otra mitad
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Align(
                              alignment: pw.Alignment.center,

                              child: pw.Text("TOTAL DE LA ÚLTIMA ENTREGA DE VALORES (b)", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                          ),

                        ),
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Text("\$${totalLiquidacion.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(),

                      ],
                    ),
                  ],
                ),
                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1.7), // La primera columna ocupará la mitad del espacio
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(0),// La segunda columna ocupará la otra mitad
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Align(
                              alignment: pw.Alignment.center,

                              child: pw.Text("VALOR TOTAL DE RECAUDACIÓN (total a + total b)", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                          ),

                        ),
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Text("\$${(totalParciales + totalLiquidacion).toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(),

                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Text("${convertirNumeroEnPalabras((totalParciales + totalLiquidacion))} (USD) DOLARES ESTADOUNIDENSES", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 5),
                // Tablas de la parte superior


                pw.Table(

                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // Primera columna
                    1: pw.FlexColumnWidth(0.5), // Segunda columna
                    2: pw.FlexColumnWidth(0.5), // Tercera columna
                    3: pw.FlexColumnWidth(2),
                    4: pw.FlexColumnWidth(1),
                  },
                  children: [

                    // Fila 1
                    pw.TableRow(children: [

                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all(),color: PdfColors.blue50),padding: pw.EdgeInsets.all(4),child: pw.Text("ANULACIONES", style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text(liquidacion.anulaciones??'', style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text("\$ ${liquidacion.valoranulaciones??''}", style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    // Fila 2
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text("SIMULACIONES", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text(liquidacion.simulaciones??'', style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text("\$ ${liquidacion.valorsimulaciones??''}", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                      pw.Container(),
                    ]),
                    // Fila 3
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all(),color: PdfColors.blue50),padding: pw.EdgeInsets.all(4), child: pw.Text("FALTANTES", style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(),left: pw.BorderSide(),bottom: pw.BorderSide())),padding: pw.EdgeInsets.all(4), child: pw.Text("\$${totalFaltantes.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.right)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(),right: pw.BorderSide(),bottom: pw.BorderSide())),padding: pw.EdgeInsets.all(8), child: pw.Text("", style: pw.TextStyle(fontSize: 1), textAlign: pw.TextAlign.center)),

                      pw.Container(),
                    ]),
                    pw.TableRow(children: [

                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text("SOBRANTES", style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(),left: pw.BorderSide(),bottom: pw.BorderSide())),padding: pw.EdgeInsets.all(4), child: pw.Text("\$ ${liquidacion.sobrante??''}", style: pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.right)),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(),right: pw.BorderSide(),bottom: pw.BorderSide())),padding: pw.EdgeInsets.all(8), child: pw.Text("", style: pw.TextStyle(fontSize: 1), textAlign: pw.TextAlign.center)),
                      pw.Container(),
                    ]),
                  ],
                ),

                // Firmas
                pw.SizedBox(height: 10),
                pw.Table(
                  columnWidths: {
                    1: pw.FlexColumnWidth(1), // La segunda columna ocupará la otra mitad
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue100,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Align(
                              alignment: pw.Alignment.center,

                              child: pw.Text("VALORES RECIBIDOS Y ENTREGADOS A CONFORMIDAD", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
                          ),

                        ),

                      ],
                    ),
                  ],
                ),





                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Cajero", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 9))),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Supervisor", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 9))),
                    pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Jefe Operativo", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 9))),

                    ]),
                    pw.TableRow(children: [
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text("${movimientos.last.nombreCajero}", textAlign: pw.TextAlign.start,style: pw.TextStyle(fontSize: 7))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text("${movimientos.last.nombreSupervisor}", textAlign: pw.TextAlign.start,style: pw.TextStyle(fontSize: 7))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text("${liquidacion.nombreSupervisor}", textAlign: pw.TextAlign.start,style: pw.TextStyle(fontSize: 7))),
                    ]),

                  ],
                ),

              ],

            );
          }
      )

  );

  pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header: Logo y nombre del peaje
                pw.Row(
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(logo, width: 60, height: 40),
                        pw.Text("Peaje ${liquidacion.idPeaje == null ? 'Desconocido' : (liquidacion.idPeaje == '1' ? 'Congoma' : 'Los Angeles')}", style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),pw.SizedBox(width: 50),
                    pw.Text('REPORTE DE CANJE Y APERTURA', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),

                  ],
                ),
                pw.SizedBox(height: 10),

                // Tablas de la parte superior
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

                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3),child: pw.Text("Nombre", style: pw.TextStyle(fontSize: 8)),),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(apertura.nombreCajero??'No registrado', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Vía", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(apertura.via??'Via no asignada', style: pw.TextStyle(fontSize: 8))),
                    ]),
                    // Fila 2

                    // Fila 3
                    pw.TableRow(children: [
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3),child: pw.Text("Fecha", style: pw.TextStyle(fontSize: 8)),),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(formatDate(DateTime.parse(apertura.fecha??'0'), [dd, '/', mm, '/', yyyy,]), style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Turno", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(apertura.turno??'Turno no asignado', style: pw.TextStyle(fontSize: 8))),
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
                        decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(3),child: pw.Text("Apertura", style: pw.TextStyle(fontSize: 8)),),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text('\$ ${totalApertura}', style: pw.TextStyle(fontSize: 8))),
                      pw.Container(),
                      pw.Container(),
                    ]),

                  ],
                ),

                pw.SizedBox(height: 15),

                pw.Table(

                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1),
                  },
                  children: [
                    // Cabecera
                    pw.TableRow(
                      children: [
                        pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Detalle como se entrega la apertura", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Detalle como se recibe la apertura", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(),
                        pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Entrega de monedas y billetes en cabinas", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text("Recepción de monedas y billetes en cabinas", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$20x  = ${apertura.entrega20D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$20x  = ${apertura.recibe20D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$20x  = ${canjes.first.entrega20D}" : "\$20x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$20x  = ${canjes.first.recibe20D}" : "\$20x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$10x  = ${apertura.entrega10D} " ,style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$10x  = ${apertura.recibe10D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$10x  = ${canjes.first.entrega10D}" : "\$10x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$10x  = ${canjes.first.recibe10D}" : "\$10x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$5x  = ${apertura.entrega5D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$5x  = ${apertura.recibe5D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$5x  = ${canjes.first.entrega5D}" : "\$5x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$5x  = ${canjes.first.recibe5D}" : "\$5x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$1x  = ${apertura.entrega1D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("\$1x  = ${apertura.recibe1D} ", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$1x  = ${canjes.first.entrega1D}" : "\$1x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text(canjes.isNotEmpty ? "\$1x  = ${canjes.first.recibe1D}" : "\$1x  = 0",style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all(), color: PdfColors.grey200),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Text("Total: \$${totalApertura}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all(), color: PdfColors.grey200),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Text("Total: \$${totalApertura}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(),
                        pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all(), color: PdfColors.grey200),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Text("Total: \$${totalPrimerCanje}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all(), color: PdfColors.grey200),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Text("Total: \$${totalPrimerCanje}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                        ),
                      ],
                    ),

                  ],
                ),
            pw.SizedBox(height: 10),

            if (canjes.length > 1) ...generarCuadrosCanjes(canjes),


                // Detalle de la última entrega de valores
                pw.SizedBox(height: 5),


                pw.Table(
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Cajero", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 9))),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Supervisor", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 9))),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text("${movimientos.last.nombreCajero}", textAlign: pw.TextAlign.start,style: pw.TextStyle(fontSize: 7))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text("${movimientos.last.nombreSupervisor}", textAlign: pw.TextAlign.start,style: pw.TextStyle(fontSize: 7))),
                    ]),

                  ],
                ),

              ],

            );
          }
      )
  );


  return pdf.save();
}

List<pw.Widget> generarCuadrosCanjes(List<Movimiento> canjes) {
  List<pw.Widget> filas = [];

  // Itera de 1 en adelante (ya que el primero lo muestras manualmente)
  for (int i = 1; i < canjes.length; i += 2) {
  final canje1 = buildCuadroCanje(canjes[i]);

  final canje2 = (i + 1 < canjes.length) ? buildCuadroCanje(canjes[i + 1]) : pw.Container();

    filas.add(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [

        pw.Expanded(child: canje1),
          pw.SizedBox(width: 90),
          pw.Text("", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),

  pw.Expanded(child: canje2),
        ],
      ),
    );

    filas.add(pw.SizedBox(height: 10)); // Espacio entre filas
  }

  return filas;
}


pw.Widget buildCuadroCanje(Movimiento canje) {
  // Calcular totales
  final totalEntrega = ((int.tryParse(canje.recibe20D ?? '0') ?? 0) * 20) +
      (int.tryParse(canje.recibe10D ?? '0') ?? 0) * 10 +
      (int.tryParse(canje.recibe5D ?? '0') ?? 0) * 5 +
      (int.tryParse(canje.recibe1D ?? '0') ?? 0) * 1;

  final totalRecibe = totalEntrega; // En este caso el total es el mismo

  return pw.Table(
    columnWidths: {
      0: pw.FlexColumnWidth(1),
      1: pw.FlexColumnWidth(1),


    },
    children: [
      // Cabecera
      pw.TableRow(
        children: [
          pw.Container(
            decoration: pw.BoxDecoration(color: PdfColors.blue50, border: pw.Border.all()),
            padding: pw.EdgeInsets.all(3),
            child: pw.Text("Entrega de monedas y billetes en cabina", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
          ),
          pw.Container(
            decoration: pw.BoxDecoration(color: PdfColors.blue50, border: pw.Border.all()),
            padding: pw.EdgeInsets.all(3),
            child: pw.Text("Recepción de monedas y billetes en cabina", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
          ),

        ],
      ),

      // Filas por denominación
      ...[
        [20, canje.entrega20D, canje.recibe20D],
        [10, canje.entrega10D, canje.recibe10D],
        [5, canje.entrega5D, canje.recibe5D],
        [1, canje.entrega1D, canje.recibe1D],
      ].map((fila) {
        final valor = fila[0] as int;
        final cantidadEntrega = fila[1] ?? '0';
        final cantidadRecibe = fila[2] ?? '0';
        return pw.TableRow(
          children: [
            pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              padding: pw.EdgeInsets.all(3),
              child: pw.Text("\$$valor x = $cantidadEntrega", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
            ),
            pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              padding: pw.EdgeInsets.all(3),
              child: pw.Text("\$$valor x = $cantidadRecibe", style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
            ),
          ],
        );
      }),

      // Fila de totales
      pw.TableRow(
        children: [
          pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(), color: PdfColors.grey200),
            padding: pw.EdgeInsets.all(3),
            child: pw.Text("Total: \$${totalEntrega}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
          ),
          pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(), color: PdfColors.grey200),
            padding: pw.EdgeInsets.all(3),
            child: pw.Text("Total: \$${totalRecibe}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
          ),

        ],
      ),
    ],
  );
}




String convertirNumeroEnPalabras(double numero) {
  if (numero == 0) return "cero";

  final unidades = [
    "",
    "uno",
    "dos",
    "tres",
    "cuatro",
    "cinco",
    "seis",
    "siete",
    "ocho",
    "nueve"
  ];
  final decenas = [
    "",
    "diez",
    "veinte",
    "treinta",
    "cuarenta",
    "cincuenta",
    "sesenta",
    "setenta",
    "ochenta",
    "noventa"
  ];
  final especiales = [
    "once",
    "doce",
    "trece",
    "catorce",
    "quince",
    "dieciséis",
    "diecisiete",
    "dieciocho",
    "diecinueve"
  ];
  final centenas = [
    "",
    "cien",
    "doscientos",
    "trescientos",
    "cuatrocientos",
    "quinientos",
    "seiscientos",
    "setecientos",
    "ochocientos",
    "novecientos"
  ];

  String convertir(int n) {
    if (n < 10) return unidades[n];
    if (n >= 11 && n < 20) return especiales[n - 11];
    if (n < 100) {
      int u = n % 10;
      return decenas[n ~/ 10] + (u > 0 ? " y ${unidades[u]}" : "");
    }
    if (n < 1000) {
      int resto = n % 100;
      return centenas[n ~/ 100] + (resto > 0 ? " ${convertir(resto)}" : "");
    }
    if (n < 1000000) {
      int miles = n ~/ 1000;
      int resto = n % 1000;
      return (miles == 1 ? "mil" : "${convertir(miles)} mil") +
          (resto > 0 ? " ${convertir(resto)}" : "");
    }
    throw Exception("Número fuera de rango");
  }

  // Separar la parte entera y los centavos
  int parteEntera = numero.toInt();
  int centavos = ((numero - parteEntera) * 100).round();

  String resultado = convertir(parteEntera);

  if (centavos > 0) {
    resultado += " con ${convertir(centavos)} centavos";
  }



  return resultado.toUpperCase();
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