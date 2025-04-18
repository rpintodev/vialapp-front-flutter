import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/pages/detalle_transaccion/detalle_transaccion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleTransaccion extends StatelessWidget {

  List<Movimiento>? movimientos;
  int? bandera;

  late DetalleTransaccionController detalleTransaccionController;



  DetalleTransaccion({@required this.movimientos,@required this.bandera}){
    detalleTransaccionController=Get.put(DetalleTransaccionController(movimientos!,bandera!));
    print('bandera: $bandera');
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 10),
                _buildDetails(),
              ],
            ),
            // Botón de menú en la esquina superior derecha
          bandera==0 && detalleTransaccionController.usuarioSession.roles?.first.id!='5'?
            Positioned(
              top: 0,
              right: 0,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.black), // Ícono de menú

                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                  onTap: () {
                      final movimiento = movimientos?.first;
                        if (movimiento != null) {
                          detalleTransaccionController.goToEditTransaccion(movimiento);
                        } else {
                          print("Error: No hay movimientos disponibles");
                        }
                    },
                    child: Text('Editar Transacción'),
                  ),
                ],
              ),
            ):Text(''),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {

      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación para cajero y supervisor
          children: [
            // Centrado del nombre del movimiento y el ícono
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        movimientos?.first.idTipoMovimiento == '1'
                            ? Icons.paid_outlined
                            : movimientos?.first.idTipoMovimiento == '2'
                            ? Icons.payments_outlined
                            : movimientos?.first.idTipoMovimiento == '3'
                            ? Icons.currency_exchange
                            : movimientos?.first.idTipoMovimiento == '4'
                            ? Icons.request_page_outlined
                            : Icons.directions_car,
                        color: Color(0xFF368983),
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${movimientos?.first.nombreMovimiento}' ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),SizedBox(width: 20),

                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    movimientos?.first.fecha ?? 'No registrado',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15), // Espaciado entre secciones
            _textInfo(
              'Supervisor',
              movimientos?.first.nombreSupervisor ?? 'No registrado',
              Icons.work,
            ),
            SizedBox(height: 10),
            if (movimientos?.first.idTipoMovimiento != '5')
              _textInfo(
                'Cajero',
                movimientos?.first.nombreCajero ?? 'No registrado',
                Icons.person,
              ),

            SizedBox(height: 10), // Espaciado entre líneas
            // Información del supervisor
            if (movimientos?.first.via != null && movimientos?.first.idTipoMovimiento != '5')
              _textInfo(
                'Via',
                movimientos?.first.via ?? 'No registrado',
                Icons.directions_car,
              ),
          ],
        ),

    );
  }

  /// Widget para mostrar información del cajero y supervisor
  Widget _textInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF368983), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF368983),
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  /// Construye los detalles dinámicos según el tipo de movimiento
  Widget _buildDetails() {
    print("Movimiento id ${movimientos?.first.idTipoMovimiento}");
    switch (int.parse(movimientos?.first.idTipoMovimiento??'1')) {
      case 1: // Apertura
        return _buildAperturaDetails();
      case 2: // Retiro Parcial
        return _buildRetiroParcialDetails();
      case 3: // Canje
        return _buildCanjeDetails();
      case 4: // Liquidación
        return _buildLiquidacionDetails();
      case 5: // Fortius
        return _buildFortiusDetails();
      case 6: // Fortius
        return _buildLiquidacionDetails();
      case 7: // Fortius
        return _buildTagDetails();
      default:
        return Text('Tipo de movimiento no reconocido');
    }
  }
  Widget _buildAperturaDetails() {
    final totalRecibido = (int.parse(movimientos?.first.recibe20D ?? '0') * 20) +
        (int.parse(movimientos?.first.recibe10D ?? '0') * 10) +
        (int.parse(movimientos?.first.recibe5D ?? '0') * 5) +
        (int.parse(movimientos?.first.recibe1D ?? '0') * 1) +
        (int.parse(movimientos?.first.recibe50C ?? '0') * 0.5).toDouble() +
        (int.parse(movimientos?.first.recibe25C ?? '0') * 0.25).toDouble();

    final totalEntregado = (int.parse(movimientos?.first.entrega10D ?? '0') * 10) +
        (int.parse(movimientos?.first.entrega5D ?? '0') * 5) +
        (int.parse(movimientos?.first.entrega1D ?? '0') * 1)+
        (int.parse(movimientos?.first.entrega50C ?? '0') * 0.5).toDouble()+
        (int.parse(movimientos?.first.entrega25C ?? '0') * 0.25).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDenominationList('Recibido:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.recibe20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.recibe10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.recibe5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.recibe1D ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),SizedBox(height: 8),SizedBox(width: 15),
        _detailRow('Total Recibido:', '\$${totalRecibido}'),SizedBox(height: 8),
        _buildDenominationList('Entregado:', {
          '\$10': {'cantidad': int.parse(movimientos?.first.entrega10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.entrega5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.entrega1D ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),
        SizedBox(height: 8),
        _detailRow('Total Entregado:', '\$${totalEntregado}'),
      ],
    );
  }

  Widget _buildDenominationList(String title, Map<String, Map<String, dynamic>> denominaciones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 6),
        Column(
          children: denominaciones.entries.map((entry) {
            final label = entry.key;
            final cantidad = entry.value['cantidad'];
            final icon = entry.value['icon'];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 50),
                    Image.asset(
                      icon,
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 15),
                    Text(
                      label,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
                Spacer(),
                Text(
                  '${cantidad}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),SizedBox(width: 50)
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(width: 100),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF368983)),
        ),SizedBox(width: 1),
      ],
    );
  }

  Widget _buildRetiroParcialDetails() {
    final totalRecibido = (int.parse(movimientos?.first.recibe20D ?? '0') * 20) +
        (int.parse(movimientos?.first.recibe10D ?? '0') * 10) +
        (int.parse(movimientos?.first.recibe5D ?? '0') * 5) +
        (int.parse(movimientos?.first.recibe1D ?? '0') * 1);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDenominationList('Recibido:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.recibe20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.recibe10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.recibe5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.recibe1D ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),SizedBox(height: 12),SizedBox(width: 15),

        _detailRow('Total:', '\$${totalRecibido}'),
      ],
    );
  }

  Widget _buildCanjeDetails() {

    final totalEntregado = (int.parse(movimientos?.first.entrega10D ?? '0') * 10) +
        (int.parse(movimientos?.first.entrega5D ?? '0') * 5) +
        (int.parse(movimientos?.first.entrega1D ?? '0') * 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDenominationList('Recibido:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.recibe20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.recibe10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.recibe5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.recibe1D ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),SizedBox(height: 8),SizedBox(width: 15),
        _buildDenominationList('Entregado:', {
          '\$10': {'cantidad': int.parse(movimientos?.first.entrega10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.entrega5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.entrega1D ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),
        SizedBox(height: 8),
        _detailRow('Total:', '\$${totalEntregado}'),
      ],
    );
  }

  Widget _buildLiquidacionDetails() {
    // Calcula el total de la liquidación actual

    final liquidacion=movimientos?.firstWhere((m)=> m.idTipoMovimiento=='4');
    final totalRecibido = (int.parse(liquidacion?.recibe20D ?? '0') * 20) +
        (int.parse(liquidacion?.recibe10D ?? '0') * 10) +
        (int.parse(liquidacion?.recibe5D ?? '0') * 5) +
        (int.parse(liquidacion?.recibe1D ?? '0') * 1) +
        (int.parse(liquidacion?.recibe1DB ?? '0') * 1) +
        (int.parse(liquidacion?.recibe2D ?? '0') * 2) +
        (int.parse(liquidacion?.recibe50C ?? '0') * 0.5).toDouble() +
        (int.parse(liquidacion?.recibe25C ?? '0') * 0.25).toDouble() +
        (int.parse(liquidacion?.recibe10C ?? '0') * 0.1).toDouble() +
        (int.parse(liquidacion?.recibe5C ?? '0') * 0.05).toDouble() +
        (int.parse(liquidacion?.recibe1C ?? '0') * 0.01).toDouble();

    // Calcula el total de los retiros parciales relacionados

    final retirosparciales=movimientos?.where((m) => m.idTipoMovimiento == '2').toList();

    final totalRetirosParciales = retirosparciales
        ?.where((mov) => mov.idTipoMovimiento == '2')
        .fold(0, (sum, mov) {
      return sum +
          (int.parse(mov.recibe20D ?? '0') * 20) +
          (int.parse(mov.recibe10D ?? '0') * 10) +
          (int.parse(mov.recibe5D ?? '0') * 5) +
          (int.parse(mov.recibe1D ?? '0') * 1);
    }) ??
        0;

    // Suma el total de la liquidación y los retiros parciales
    final totalGeneral = totalRecibido + totalRetirosParciales;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Detalles de la liquidación
        _buildDenominationList('Recibido:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.recibe20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.recibe10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.recibe5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$2': {'cantidad': int.parse(movimientos?.first.recibe2D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.recibe1D ?? '0'), 'icon': 'assets/img/moneda.png'},
          '50C': {'cantidad': int.parse(movimientos?.first.recibe50C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '25C': {'cantidad': int.parse(movimientos?.first.recibe25C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '10C': {'cantidad': int.parse(movimientos?.first.recibe10C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '5C': {'cantidad': int.parse(movimientos?.first.recibe5C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '1C': {'cantidad': int.parse(movimientos?.first.recibe1C ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),
        SizedBox(height: 12),
        _detailRow('Total Recibido:', '\$${totalRecibido.toStringAsFixed(2)}'),
        SizedBox(height: 5),
        _detailRow('Retiros Parciales:', '\$${totalRetirosParciales.toStringAsFixed(2)}'),
        SizedBox(height: 12),
        // Detalle del total general de la liquidación
        _detailRow('Total General:', '\$${totalGeneral.toStringAsFixed(2)}'),
        SizedBox(height: 12),
        _confirmButton(movimientos?.first.idturno??'0'),
        SizedBox(height: 10),
        detalleTransaccionController.usuarioSession.roles?.first.id=='6'?
        _canjeBottom(movimientos?.first.idturno??''):Text(''),
      ],
    );
  }




  Widget _buildFortiusDetails() {
    final totalEntregado = (int.parse(movimientos?.first.entrega20D ?? '0') * 20) + (int.parse(movimientos?.first.entrega10D ?? '0') * 10) + (int.parse(movimientos?.first.entrega5D ?? '0') * 5) +
        (int.parse(movimientos?.first.entrega1D ?? '0') * 1)+ (int.parse(movimientos?.first.entrega50C ?? '0') * 0.5).toDouble() +
        (int.parse(movimientos?.first.entrega25C ?? '0') * 0.25).toDouble() +(int.parse(movimientos?.first.entrega10C ?? '0') * 0.1).toDouble() +(int.parse(movimientos?.first.entrega5C ?? '0') * 0.05).toDouble() +
        (int.parse(movimientos?.first.entrega1C ?? '0') * 0.01).toDouble() ;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        movimientos?.first.recibe5D=='0'?

        _buildDenominationList('Entregado:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.entrega20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.entrega10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.entrega5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.entrega1D ?? '0'), 'icon': 'assets/img/moneda.png'},
          '50C': {'cantidad': int.parse(movimientos?.first.entrega50C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '25C': {'cantidad': int.parse(movimientos?.first.entrega25C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '10C': {'cantidad': int.parse(movimientos?.first.entrega10C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '5C': {'cantidad': int.parse(movimientos?.first.entrega5C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '1C': {'cantidad': int.parse(movimientos?.first.entrega1C ?? '0'), 'icon': 'assets/img/moneda.png'},
        }):_buildDenominationList('Entregado:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.entrega20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.entrega10D ?? '0'), 'icon': 'assets/img/billete.png'},

        }),SizedBox(height: 12),SizedBox(width: 15),
        if(movimientos?.first.recibe5D!='0')
        _buildDenominationList('Recibido:', {
          '\$5': {'cantidad': int.parse(movimientos?.first.recibe5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.recibe1D ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),

        _detailRow('Total:', '\$${totalEntregado}'),

      ],
    );
  }

  Widget _buildTagDetails() {
    // Calcula el total de la liquidación actual
    final totalRecibido = (int.parse(movimientos?.first.recibe20D ?? '0') * 20) +
        (int.parse(movimientos?.first.recibe10D ?? '0') * 10) +
        (int.parse(movimientos?.first.recibe5D ?? '0') * 5) +
        (int.parse(movimientos?.first.recibe1D ?? '0') * 1) +
        (int.parse(movimientos?.first.recibe1DB ?? '0') * 1) +
        (int.parse(movimientos?.first.recibe2D ?? '0') * 2) +
        (int.parse(movimientos?.first.recibe50C ?? '0') * 0.5).toDouble() +
        (int.parse(movimientos?.first.recibe25C ?? '0') * 0.25).toDouble() +
        (int.parse(movimientos?.first.recibe10C ?? '0') * 0.1).toDouble() +
        (int.parse(movimientos?.first.recibe5C ?? '0') * 0.05).toDouble() +
        (int.parse(movimientos?.first.recibe1C ?? '0') * 0.01).toDouble();


    // Suma el total de la liquidación y los retiros parciales
    final totalGeneral = totalRecibido ;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Detalles de la liquidación
        _buildDenominationList('Recibido:', {
          '\$20': {'cantidad': int.parse(movimientos?.first.recibe20D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$10': {'cantidad': int.parse(movimientos?.first.recibe10D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$5': {'cantidad': int.parse(movimientos?.first.recibe5D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$2': {'cantidad': int.parse(movimientos?.first.recibe2D ?? '0'), 'icon': 'assets/img/billete.png'},
          '\$1': {'cantidad': int.parse(movimientos?.first.recibe1D ?? '0'), 'icon': 'assets/img/moneda.png'},
          '50C': {'cantidad': int.parse(movimientos?.first.recibe50C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '25C': {'cantidad': int.parse(movimientos?.first.recibe25C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '10C': {'cantidad': int.parse(movimientos?.first.recibe10C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '5C': {'cantidad': int.parse(movimientos?.first.recibe5C ?? '0'), 'icon': 'assets/img/moneda.png'},
          '1C': {'cantidad': int.parse(movimientos?.first.recibe1C ?? '0'), 'icon': 'assets/img/moneda.png'},
        }),

        SizedBox(height: 12),
        // Detalle del total general de la liquidación
        _detailRow('Total General:', '\$${totalGeneral.toStringAsFixed(2)}'),
        SizedBox(height: 12),
        _confirmButton(movimientos?.first
            .idturno??'0'),
      ],
    );
  }



  Widget _confirmButton(String idturno) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          detalleTransaccionController.goToReportes(idturno);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Reporte de Liquidación',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _canjeBottom(String idturno) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          detalleTransaccionController.goToFaltantes(idturno,0);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF368983),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Agregar Faltantes/Sobrantes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
