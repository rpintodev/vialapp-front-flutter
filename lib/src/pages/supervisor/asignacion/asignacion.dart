import 'package:asistencia_vial_app/src/pages/supervisor/asignacion/asignacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/movimiento.dart';
import '../../../models/usuario.dart';

class AsignacionPage extends StatelessWidget {
  AsignacionController asignacionController = Get.put(AsignacionController());


  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
      length: asignacionController.estados.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AppBar(
            flexibleSpace: Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Asignación de Turnos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      asignacionController.getEstados(); // método para recargar, o llama getUsuarios si prefieres
                    },
                    icon: Icon(Icons.refresh, color: Colors.black),
                    tooltip: 'Recargar',
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              tabAlignment: TabAlignment.center,
              isScrollable: true, // Permite desplazamiento
              indicatorColor: Color(0xFF368983), // Color del indicador
              labelColor: Colors.black, // Color de las etiquetas seleccionadas
              unselectedLabelColor: Colors.grey[400], // Color de las etiquetas no seleccionadas
              tabs: List<Widget>.generate(
                asignacionController.estados.length,
                    (index) {
                  return Tab(
                    child: Text(
                      asignacionController.estados[index].nombre ?? ' ',
                    ),
                  );
                },
              ),
            ),
          ),

        ),
        body:  RefreshIndicator(
          onRefresh: _pullToRefresh,
          child: TabBarView(
            children: List<Widget>.generate(asignacionController.estados.length, (index2) {
              return FutureBuilder(
                future: asignacionController
                    .getUsuarios((index2 + 1).toString(),asignacionController.usuario.idPeaje??'1'), // Cambia para manejar los grupos
                builder: (context, AsyncSnapshot<List<Usuario>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index) {
                        return _cardUsuario(
                            context, snapshot.data![index], index2); // Pasamos el índice de la tarjeta aquí
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }),
          ),
        ),),
    ));
  }


  Future<void> _pullToRefresh() async {
    asignacionController.getUsuarios(
        "1", asignacionController.usuario.idPeaje ?? '1');
  }


  Widget _cardUsuario(BuildContext context, Usuario usuario, int cardIndex) {
    return FutureBuilder<List<Movimiento?>>(
      future: asignacionController.getMovimientoPorUsuario(usuario.idTurno ?? ''),
      builder: (context, snapshot) {
        String aperturaEstado = "Sin Apertura";
        String estadoLiquidacion="Sin Liquidar";

        if (snapshot.connectionState == ConnectionState.waiting) {
          aperturaEstado = "Cargando...";
          estadoLiquidacion="Cargando...";

        } else if (snapshot.hasData) {
          List<Movimiento?> movimientosApertura = snapshot.data!.where((m) => m?.idTipoMovimiento == '1').toList();
          if (movimientosApertura.isNotEmpty) {
            // Si hay al menos uno, tomar el primero
            aperturaEstado = _validarApertura(movimientosApertura.first!);
          } else {
            // No hay aperturas
            aperturaEstado = "Sin Apertura";
          }

          List<Movimiento?> movimientosLiquidacion = snapshot.data!.where((m) => m?.idTipoMovimiento == '4').toList();
          if (movimientosLiquidacion.isNotEmpty) {
            // Si hay al menos uno, tomar el primero
            estadoLiquidacion = _validarEstadoLiquidacion(movimientosLiquidacion.first!);
          } else {
            // No hay aperturas
            estadoLiquidacion = "No hay apertura registrada";
          }


        }


        return GestureDetector(
          onTap: () => cardIndex == 2
              ? asignacionController.openBottomSheetLiquidacion(context, usuario.idTurno ?? '0',2)
              : asignacionController.openBottomSheet(context, usuario.idTurno ?? '0'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/img/no-image.png',
                    image: usuario.imagen ?? '',
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/img/no-image.png');
                    },
                  )
                ),
                title: Text(
                  '${usuario.nombre} ${usuario.apellido}' ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario.via != null ? 'Vía ${usuario.via}' : 'Vía no asignada',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      cardIndex == 2
                          ? estadoLiquidacion
                          : cardIndex == 1
                          ? (aperturaEstado == "Apertura Completa" || aperturaEstado == "Apertura Incompleta"
                          ? "Apertura Entregada"
                          : "Sin Apertura")
                          : aperturaEstado,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cardIndex == 2
                            ? (estadoLiquidacion == "Liquidado"
                            ? Colors.green
                            : estadoLiquidacion == "Sin liquidar"
                            ? Colors.redAccent
                            : Colors.orangeAccent)
                            : cardIndex == 1
                            ? (aperturaEstado == "Apertura Completa" || aperturaEstado == "Apertura Incompleta"
                            ? Colors.green
                            : Colors.redAccent)
                            : aperturaEstado == "Apertura Completa"
                            ? Colors.green
                            : aperturaEstado == "Cargando..."
                            ? Colors.blue
                            : aperturaEstado == "Sin Apertura"
                            ? Colors.redAccent
                            : Colors.orangeAccent,

                      ),
                    ),

                  ],
                ),
                trailing:
                asignacionController.usuario.roles?.first.id !='5' ?

                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.grey[400],
                    size: 16.0,
                  ),
                  itemBuilder: (BuildContext context) {
                    return _getOptionsForCard(context, cardIndex, usuario, usuario.id ?? '1', usuario.idTurno ?? '1',aperturaEstado);
                  },
                ):Text(''),
              ),
            ),
          ),
        );
      },
    );
  }



  List<PopupMenuEntry<String>> _getOptionsForCard(BuildContext context, int cardIndex, Usuario usuario, String idCajero,String idTurno, String aperturaEstado) {
    asignacionController.getApertura(usuario.idTurno??'');
    asignacionController.getFaltante(usuario.idTurno??'');
    // Obtén la apertura individualmente
    // Valida el estado de apertura


    print("Apertura estado ${aperturaEstado}");

    switch (cardIndex) {
      case 0:
        return [
          PopupMenuItem<String>(
            value: "Canje",
            child: Row(
              children: [
                Icon(Icons.currency_exchange, color: Colors.blue),
                SizedBox(width: 10),
                Text("Canje"),
              ],
            ),
            onTap:() => asignacionController.goToCanje(usuario),
          ),
          PopupMenuItem<String>(
            value: "Rparcial",
            child: Row(
              children: [
                Icon(Icons.paid
                    , color: Colors.green),
                SizedBox(width: 10),
                Text("Retiro Parcial"),
              ],
            ),
            onTap:() => asignacionController.goToRetiroParcial(usuario),

          ),

          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.arrow_circle_down, color: Colors.green),
                SizedBox(width: 10),
                Text("Retiro Apertura"),
              ],
            ),
            onTap: () {
              aperturaEstado == "Sin Apertura" ?
              asignacionController.goToApertura(usuario)
                :
              asignacionController.goToRetiroApertura(usuario, asignacionController.movimiento);

            },
          ),
      if(asignacionController.usuario.roles?.first.id=='2')...[

          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.directions_car, color: Colors.yellow),
                SizedBox(width: 10),
                Text("Cambio de Vía"),
              ],
            ),
            onTap: () => Future.delayed(
              Duration.zero,
                  () => _showViaSelectionDialog(context,idTurno),
            ),
          ),
          ],
          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.edit_calendar_outlined, color: Colors.cyan),
                SizedBox(width: 10),
                Text("Parte de Trabajo"),
              ],
            ),

            onTap:() =>
            asignacionController.faltante.partetrabajo== null ?
            asignacionController.goToFaltantes(usuario,1):Get.dialog(
              AlertDialog(
                title: Text("Parte de Trabajo registrado!"),
                content: Text("Ya se ha registrado el parte de trabajo"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Aceptar"),
                  ),
                ],
              ),
            ),

          ),
        if(asignacionController.usuario.roles?.first.id=='2')...[

          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.price_check, color: Colors.orange),
                SizedBox(width: 10),
                Text("Liquidacion temprana"),
              ],
            ),
            onTap:() => aperturaEstado == "Apertura Completa" ?
            asignacionController.goToLiquidaciones(usuario):
            Get.dialog(
              AlertDialog(
                title: Text("Apertura Incompleta!"),
                content: Text("No se ha retirado la apertura de ${usuario.nombre} ${usuario.apellido}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Cierra el diálogo
                    },
                    child: Text("Regresar"),
                  ),
                  TextButton(
                    onPressed: () {
                      asignacionController.goToRetiroApertura(usuario, asignacionController.movimiento); // Cierra el diálogo
                    },
                    child: Text("Retirar apertura"),
                  ),
                ],
              ),
            ),
          ), ],
        if(asignacionController.usuario.roles?.first.id=='1')...[
          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.arrow_forward_ios_sharp, color: Colors.orange),
                SizedBox(width: 10),
                Text("Enviar a Boveda"),
              ],
            ),
            onTap:() =>
            asignacionController.enviarBoveda(usuario.id??'',usuario.idTurno??''),

          ),
         ],
        ];
      case 1:
        return [
        if(asignacionController.usuario.roles?.first.id=='2')...[

        PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.arrow_circle_up
                    , color: Colors.green),
                SizedBox(width: 10),
                Text("Apertura"),
              ],
            ),
            onTap: () {
              if (asignacionController.movimiento.id==null) {
                print("Valor de movimiento: ${asignacionController.movimiento.id}");
                asignacionController.goToApertura(usuario);

              } else {
                usuario.idRol!='4'?
                Get.dialog(
                  AlertDialog(
                    title: Text("Apertura Registrada!"),
                    content: Text("Ya se ha registrado la apertura previamente."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back(); // Cierra el diálogo
                        },
                        child: Text("Aceptar"),
                      ),
                    ],
                  ),
                ):
                asignacionController.goToRetiroApertura(usuario, asignacionController.movimiento);
              }
            },

          ),
          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.price_check, color: Colors.orange),
                SizedBox(width: 10),
                Text("Liquidacion"),
              ],
            ),
            onTap:() => aperturaEstado == "Apertura Completa" ?
            asignacionController.goToLiquidaciones(usuario):
            Get.dialog(
              AlertDialog(
                title: Text("Apertura Incompleta!"),
                content: Text("No se ha retirado la apertura de ${usuario.nombre} ${usuario.apellido}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Cierra el diálogo
                    },
                    child: Text("Regresar"),
                  ),
                  TextButton(
                    onPressed: () {
                      asignacionController.goToRetiroApertura(usuario, asignacionController.movimiento); // Cierra el diálogo
                    },
                    child: Text("Retirar apertura"),
                  ),
                ],
              ),
            ),

          ),
          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.directions_car, color: Colors.yellow),
                SizedBox(width: 10),
                Text("Asignacion de Vía"),
              ],
            ),
            onTap: () => Future.delayed(
              Duration.zero,
                  () => _showViaSelectionDialog(context,idTurno),
            ),
          ),

          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.blue),
                SizedBox(width: 10),
                Text("Enviar a Turno "),
              ],
            ),
            onTap: () {

              aperturaEstado == "Sin Apertura" ?
              Get.dialog(
                AlertDialog(
                  title: Text("Sin Apertura!"),
                  content: Text("No se puede enviar a turno sin asignar una apertura al usuario: ${usuario.nombre} ${usuario.apellido}"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back(); // Cierra el diálogo
                      },
                      child: Text("Regresar"),
                    ),
                    TextButton(
                      onPressed: () {
                        asignacionController.goToApertura(usuario); // Cierra el diálogo
                      },
                      child: Text("Asignar apertura"),
                    ),
                  ],
                ),
              ):
              // Mostrar el cuadro de diálogo de confirmación
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showTurnoConfirmationDialog(context, usuario);
              });
            },

          ),

          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.orange),
                SizedBox(width: 10),
                Text("Eliminar"),
              ],
            ),
            onTap: () =>

            aperturaEstado == "Sin Apertura" ?
            // Mostrar el cuadro de diálogo de confirmación
            WidgetsBinding.instance.addPostFrameCallback((_) {
            _showDeleteConfirmationDialog(context, usuario);
            }):
            Get.dialog(
              AlertDialog(
                title: Text("Apertura Incompleta!"),
                content: Text("No se ha retirado la apertura de ${usuario.nombre} ${usuario.apellido}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Cierra el diálogo
                    },
                    child: Text("Regresar"),
                  ),
                  TextButton(
                    onPressed: () {
                      asignacionController.goToRetiroApertura(usuario, asignacionController.movimiento); // Cierra el diálogo
                    },
                    child: Text("Retirar apertura"),
                  ),
                ],
              ),
            ),






          ),
        ],
        ];
      case 2:
        return [
        if(asignacionController.usuario.roles?.first.id=='6')...[

         PopupMenuItem<String>(
            value: "Faltante",
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.orange),
                SizedBox(width: 10),
                Text("Faltante"),
              ],
            ),
            onTap: () {
              asignacionController.goToFaltantes(usuario,0);
            },
          ),
        ],
          PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.request_page, color: Colors.green),
                SizedBox(width: 10),
                Text("Reporte"),
              ],
            ),
            onTap:() => asignacionController.goToReportes(usuario),
          ),
        ];
      default:
        return [];
    }
  }



  String _validarApertura(Movimiento movimiento) {
    final totalEntregado =
        (int.tryParse(movimiento.entrega10D ?? '0') ?? 0) * 10 +
            (int.tryParse(movimiento.entrega5D ?? '0') ?? 0) * 5 +
            (int.tryParse(movimiento.entrega1D ?? '0') ?? 0) * 1 +
            ((int.tryParse(movimiento.entrega50C ?? '0') ?? 0) * 0.5).toDouble() +
            ((int.tryParse(movimiento.entrega25C ?? '0') ?? 0) * 0.25).toDouble() +
            ((int.tryParse(movimiento.entrega5C ?? '0') ?? 0) * 0.05).toDouble() +
            ((int.tryParse(movimiento.entrega10C ?? '0') ?? 0) * 0.1).toDouble() +
            ((int.tryParse(movimiento.entrega1C ?? '0') ?? 0) * 0.01).toDouble()

    ;

    final totalRecibido =
        (int.tryParse(movimiento.recibe20D ?? '0') ?? 0) * 20+
            (int.tryParse(movimiento.recibe10D ?? '0') ?? 0) * 10+
            (int.tryParse(movimiento.recibe5D ?? '0') ?? 0) * 5+
            (int.tryParse(movimiento.recibe1D ?? '0') ?? 0) * 1+
            ((int.tryParse(movimiento.recibe50C ?? '0') ?? 0) * 0.5).toDouble() +
            ((int.tryParse(movimiento.recibe25C ?? '0') ?? 0) * 0.25).toDouble() +
            ((int.tryParse(movimiento.recibe5C ?? '0') ?? 0) * 0.05).toDouble() +
            ((int.tryParse(movimiento.recibe10C ?? '0') ?? 0) * 0.1).toDouble() +
            ((int.tryParse(movimiento.recibe1C ?? '0') ?? 0) * 0.1).toDouble()
    ;

    return ( totalEntregado-totalRecibido) == 0
        ? "Apertura Completa"
        : "Apertura Incompleta";
    }

  String _validarEstadoLiquidacion(Movimiento movimiento) {
    return (movimiento.estado=='1')
        ? "Liquidado"
        : "Sin liquidar";
  }


  void _showDeleteConfirmationDialog(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text(
            "¿Estás seguro de eliminar el turno de ${usuario.nombre} ${usuario.apellido}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo

                asignacionController.deleteTurno(usuario.id??'1');
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _showTurnoConfirmationDialog(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Turno"),
          content: Text(
            "¿Estás seguro que deseas enviar a Turno a ${usuario.nombre} ${usuario.apellido}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo

                asignacionController.enviarTurno(usuario.id??'1');
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }


  void _showViaSelectionDialog(BuildContext context, String idTurno) {
    // Lista de números de las vías
    List<int> vias = [1, 2, 3, 4, 5, 6, 7, 8, 104, 105];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Selecciona una vía",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 botones por fila
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: vias.length, // Número de vías basado en la lista
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el diálogo
                    print("Vía ${vias[index]} seleccionada");
                    asignacionController.updateVia(vias[index].toString(),idTurno);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF368983),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "${vias[index]}", // Muestra el número exacto de la vía
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (vias[index] == 104 || vias[index] == 105) ? 7 : 16,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


}