import 'package:date_format/date_format.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

Future<Uint8List> pdfRecaudaciones(Usuario usuario, List<Movimiento> movimientos) async {
  final pdf = pw.Document();

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/img/vial25color.png')).buffer.asUint8List(),
  );

  // Filtrar retiros parciales
  final retirosParciales = movimientos.where((m) => m.idTipoMovimiento == '2').toList();
  final retirosParcialesTurno1 = movimientos.where((m) => m.turno == '1' && (m.idTipoMovimiento == '2'|| m.idTipoMovimiento == '4') ).toList();
  final retirosParcialesTurno2 = movimientos.where((m) => m.turno == '2' && (m.idTipoMovimiento == '2'|| m.idTipoMovimiento == '4')).toList();
  final retirosParcialesTurno3 = movimientos.where((m) => m.turno == '3' && (m.idTipoMovimiento == '2'|| m.idTipoMovimiento == '4')).toList();

  // Detalle de la última entrega de valores
  final liquidacion = movimientos.firstWhere((m) => m.idTipoMovimiento == '4', orElse: () => Movimiento());

  final liquidacionesTurno1 = movimientos.where((m) => m.turno == '1' && m.idTipoMovimiento == '4').toList();
  final liquidacionesTurno2 = movimientos.where((m) => m.turno == '2' && m.idTipoMovimiento == '4').toList();
  final liquidacionesTurno3 = movimientos.where((m) => m.turno == '3' && m.idTipoMovimiento == '4').toList();


  final faltantes = movimientos.where((m) => m.idTipoMovimiento == '6').toList();

  final faltantesTurno1 = movimientos.where((m) => m.turno == '1' && m.idTipoMovimiento == '6').toList();
  final faltantesTurno2 = movimientos.where((m) => m.turno == '2' && m.idTipoMovimiento == '6').toList();
  final faltantesTurno3 = movimientos.where((m) => m.turno == '3' && m.idTipoMovimiento == '6').toList();

  final fecha = retirosParcialesTurno2.isNotEmpty
      ? formatDate(DateTime.parse(retirosParcialesTurno2.first.fecha ?? '0000-00-00'), [dd, ' / ', mm, ' / ', yyyy])
      : formatDate(DateTime.now(),[dd, ' / ', mm, ' / ', yyyy]);

  final totalRecaudacionTurno1 = _calculateTotalRecaudacion(retirosParcialesTurno1, liquidacionesTurno1);
  final totalRecaudacionTurno2 = _calculateTotalRecaudacion(retirosParcialesTurno2, liquidacionesTurno2);
  final totalRecaudacionTurno3 = _calculateTotalRecaudacion(retirosParcialesTurno3, liquidacionesTurno3);
  final totalRecaudacionGeneral = totalRecaudacionTurno1 + totalRecaudacionTurno2 + totalRecaudacionTurno3;



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
                        pw.Text("Peaje ${usuario.nombrePeaje}", style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),pw.SizedBox(width: 50),
                    pw.Text('CONSOLIDADO DIARIO DE APERTURA, RENDICIÓN DE CAJA \n E INCIDENCIAS', style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),

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
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(fecha, style: pw.TextStyle(fontSize: 8))),
                      pw.Container(color: PdfColors.blue50,padding: pw.EdgeInsets.all(3), child: pw.Text("Guía de Remisión", style: pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(usuario.idTurno??'', style: pw.TextStyle(fontSize: 8))),
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
                        decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5),child: pw.Text("Recaudacion total", style: pw.TextStyle(fontSize: 8)),),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text('\$ ${totalRecaudacionGeneral}', style: pw.TextStyle(fontSize: 10))),
                      pw.Container(),
                      pw.Container(),
                    ]),

                  ],
                ),
                pw.SizedBox(height: 3),



                buildTurnoTables(
                  movimientosTurno1: retirosParcialesTurno1,
                  movimientosTurno2: retirosParcialesTurno2,
                  movimientosTurno3: retirosParcialesTurno3,
                  liquidacionesTurno1: liquidacionesTurno1,
                  liquidacionesTurno2: liquidacionesTurno2,
                  liquidacionesTurno3: liquidacionesTurno3,
                  faltantesTurno1: faltantesTurno1,
                  faltantesTurno2: faltantesTurno2,
                  faltantesTurno3: faltantesTurno3,
                ),
                pw.SizedBox(height: 5),
                pw.Table(
                  columnWidths: {
                    1: pw.FlexColumnWidth(1), // La segunda columna ocupará la otra mitad
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),
                          padding: pw.EdgeInsets.all(3),
                          child: pw.Align(
                              alignment: pw.Alignment.center,

                              child: pw.Text("RESPONSABLE DE VALORES", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))
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
                  },
                  children: [
                    pw.TableRow(children: [
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Supervisor Turno 1", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 7))),
                      pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(3), child: pw.Text("Supervisor Turno 2", textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 7))),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text("${movimientos.last.nombreSupervisor}", textAlign: pw.TextAlign.start,style: pw.TextStyle(fontSize: 7))),
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
//ssssss

pw.Widget buildTurnoTables({
  required List<Movimiento> movimientosTurno1,
  required List<Movimiento> movimientosTurno2,
  required List<Movimiento> movimientosTurno3,
  required List<Movimiento> liquidacionesTurno1,
  required List<Movimiento> liquidacionesTurno2,
  required List<Movimiento> liquidacionesTurno3,
  required List<Movimiento> faltantesTurno1,
  required List<Movimiento> faltantesTurno2,
  required List<Movimiento> faltantesTurno3,
}) {

  final totalFaltantesTurno1 = _calculateTotalFaltantes(faltantesTurno1);
  final totalFaltantesTurno2 = _calculateTotalFaltantes(faltantesTurno2);
  final totalFaltantesTurno3 = _calculateTotalFaltantes(faltantesTurno3);



  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      _buildTurnoTable('Turno 1', movimientosTurno1, liquidacionesTurno1,totalFaltantesTurno1),
      pw.SizedBox(height: 2),
      _buildTurnoTable('Turno 2', movimientosTurno2, liquidacionesTurno2,totalFaltantesTurno2),
      pw.SizedBox(height: 2),
      _buildTurnoTable('Turno 3', movimientosTurno3, liquidacionesTurno3,totalFaltantesTurno3),
    ],
  );
}

pw.Widget _buildTurnoTable(String titulo, List<Movimiento> movimientosTurno, List<Movimiento> liquidacionesTurno, int totalFaltantesTurno) {
  final cajerosRows = _buildCajerosRows(movimientosTurno, liquidacionesTurno);

  // Suma totales del turno directamente
  final totalRecaudacionTurno = cajerosRows.fold<double>(
    0,
        (sum, row) => sum + (row['recaudacionTotal'] as double),

  );

  final jefeOperativo = movimientosTurno.isNotEmpty
      ? movimientosTurno.first.nombreSupervisor ?? 'Sin supervisor'
      : 'Sin supervisor';


  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Jefe Operativo:  ${jefeOperativo}  - ${titulo}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),


      pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: {
          0: pw.FlexColumnWidth(3), // Nombre
          1: pw.FlexColumnWidth(1), // Primera
          2: pw.FlexColumnWidth(1), // Segunda
          3: pw.FlexColumnWidth(1), // Tercera
          4: pw.FlexColumnWidth(1), // Cuarta
          5: pw.FlexColumnWidth(1), // Quinta
          6: pw.FlexColumnWidth(1), // Sexta
          7: pw.FlexColumnWidth(2), // Total de retiros
          8: pw.FlexColumnWidth(2), // Última entrega
          9: pw.FlexColumnWidth(2.5), // Recaudación total
        },
        children: [
          // Cabecera de la tabla
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColors.blue50),
            children: [
              pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('Nombre', style: pw.TextStyle(fontSize: 7))),
              ...['1era', '2da', '3era', '4ta', '5ta', '6ta']
                  .map((titulo) => pw.Padding(
                padding: pw.EdgeInsets.all(4),
                child: pw.Text(titulo, style: pw.TextStyle(fontSize: 8)),
              ))
                  .toList(),
              pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('Total Retiros', style: pw.TextStyle(fontSize: 7))),
              pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('Última Entrega', style: pw.TextStyle(fontSize: 7))),
              pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('Recaudación Total', style: pw.TextStyle(fontSize: 7))),
            ],
          ),
          ...cajerosRows.map((row) => pw.TableRow(children: row['widgets'])),
          // Fila de total por turno

        ],
      ),
      pw.Table(
        columnWidths: {
          0: pw.FlexColumnWidth(3), // Nombre
          1: pw.FlexColumnWidth(1), // Primera
          2: pw.FlexColumnWidth(1), // Segunda
          3: pw.FlexColumnWidth(1), // Tercera
          4: pw.FlexColumnWidth(1), // Cuarta
          5: pw.FlexColumnWidth(1), // Quinta
          6: pw.FlexColumnWidth(1), // Sexta
          7: pw.FlexColumnWidth(2), // Total de retiros
          8: pw.FlexColumnWidth(2.1), // Última entrega
          9: pw.FlexColumnWidth(2), // Cuarta columna
        },
        children: [

          // Fila 1
          pw.TableRow(children: [
            pw.Container(
              decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(4),child: pw.Text("REPOSICIÓN", style: pw.TextStyle(fontSize: 7)),),
            pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(4), child: pw.Text('\$ ${totalFaltantesTurno}', style: pw.TextStyle(fontSize: 7))),

            pw.Container(),
            pw.Container(),
            pw.Container(),
            pw.Container(),
            pw.Container(),
            pw.Container(
              decoration: pw.BoxDecoration(color: PdfColors.blue50,border: pw.Border.all()),padding: pw.EdgeInsets.all(5),child: pw.Text("TOTAL TURNO", style: pw.TextStyle(fontSize: 8)),),
            pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),padding: pw.EdgeInsets.all(5), child: pw.Text('\$ ${totalRecaudacionTurno+totalFaltantesTurno}', style: pw.TextStyle(fontSize: 8))),

          ]),

        ],
      ),
    ],
  );
}

List<Map<String, dynamic>> _buildCajerosRows(List<Movimiento> movimientosTurno, List<Movimiento> liquidacionesTurno) {
  final cajeros = movimientosTurno.map((m) => m.nombreCajero).toSet().toList();

  return cajeros.map((cajero) {
    final movimientosCajero = movimientosTurno.where((m) => m.nombreCajero == cajero && m.idTipoMovimiento == '2').toList();
    final liquidacionesCajero = liquidacionesTurno.where((m) => m.nombreCajero == cajero && m.idTipoMovimiento == '4').toList();

    // Calcular valores
    final valores = List.generate(6, (index) {
      if (movimientosCajero.length > index) {
        final movimiento = movimientosCajero[index];
        return ((int.tryParse(movimiento.recibe20D ?? '0') ?? 0) * 20) +
            ((int.tryParse(movimiento.recibe10D ?? '0') ?? 0) * 10) +
            ((int.tryParse(movimiento.recibe1D ?? '0') ?? 0) * 1) +
            ((int.tryParse(movimiento.recibe5D ?? '0') ?? 0) * 5);
      }
      return 0;
    });

    // Total de retiros y última entrega
    final totalRetiros = valores.reduce((sum, value) => sum + value);
    double ultimaEntrega = liquidacionesCajero.fold(0, (sum, m) {
      return sum +
          ((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
          ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
          ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
          ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1)+
          ((int.tryParse(m.recibe1DB ?? '0') ?? 0) * 1)+
          ((int.tryParse(m.recibe2D ?? '0') ?? 0) * 2)+
          ((int.tryParse(m.recibe50C ?? '0') ?? 0) * 0.5).toDouble()+
          ((int.tryParse(m.recibe25C ?? '0') ?? 0) * 0.25).toDouble()+
          ((int.tryParse(m.recibe10C ?? '0') ?? 0) * 0.1).toDouble()+
          ((int.tryParse(m.recibe5C ?? '0') ?? 0) * 0.05).toDouble()+
          ((int.tryParse(m.recibe1C ?? '0') ?? 0) * 0.01).toDouble();
    });

    final recaudacionTotal = totalRetiros + ultimaEntrega;

    return {
      'recaudacionTotal': recaudacionTotal,
      'widgets': [
        pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text(cajero ?? '', style: pw.TextStyle(fontSize: 7))),
        ...valores.map((valor) => pw.Padding(
          padding: pw.EdgeInsets.all(3),
          child: pw.Text('$valor', style: pw.TextStyle(fontSize: 7)),
        )),
        pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('$totalRetiros', style: pw.TextStyle(fontSize: 7))),
        pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('$ultimaEntrega', style: pw.TextStyle(fontSize: 7))),
        pw.Padding(padding: pw.EdgeInsets.all(3), child: pw.Text('$recaudacionTotal', style: pw.TextStyle(fontSize: 7))),
      ],
    };
  }).toList();
}

int _calculateTotalFaltantes(List<Movimiento> faltantes) {
  return faltantes.fold<int>(
    0,
        (sum, m) =>
    sum +
        (((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
            ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
            ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
            ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1)) -
            (((int.tryParse(m.entrega10D ?? '0') ?? 0) * 10) +
            ((int.tryParse(m.entrega5D ?? '0') ?? 0) * 5) +
            ((int.tryParse(m.entrega1D ?? '0') ?? 0) * 1)),
  );
}


double _calculateTotalRecaudacion(List<Movimiento> movimientos, List<Movimiento> liquidaciones) {

  final movimientosCajero = movimientos.where((m) => m.idTipoMovimiento == '2').toList();
  final liquidacionesCajero = liquidaciones.where((m) =>  m.idTipoMovimiento == '4').toList();

  final totalMovimientos = movimientosCajero.fold<int>(
    0,
        (sum, m) =>
    sum +
        ((int.tryParse(m.recibe20D ?? '0') ?? 0) * 20) +
        ((int.tryParse(m.recibe10D ?? '0') ?? 0) * 10) +
        ((int.tryParse(m.recibe5D ?? '0') ?? 0) * 5) +
        ((int.tryParse(m.recibe1D ?? '0') ?? 0) * 1) ,
  );

  final totalLiquidaciones = liquidacionesCajero.fold<double>(
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