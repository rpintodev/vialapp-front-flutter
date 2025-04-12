
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../models/usuario.dart';
import 'boveda_controller.dart';

class BovedaPage extends StatelessWidget {
  final BovedaController bovedaSupController = Get.put(BovedaController());
  final Usuario usuario = Usuario.fromJson(GetStorage().read('usuario') ?? {});


  @override
  Widget build(BuildContext context) {
    // Llamar a la función para cargar la bóveda
    bovedaSupController.getBoveda(usuario.idPeaje ?? '0');

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: RefreshIndicator(
        onRefresh: _pullToRefresh, // 🛠 Pull-to-Refresh
        child: Column(
          children: [
            Obx(() => _headerSection(context)), // Encabezado dinámico
            Expanded(
              child: Obx(() => _denominacionesList(context)), // Lista dinámica
            ),
          ],
        ),
      ),
    );
  }

  /// 🟢 **Función para refrescar la pantalla al deslizar hacia abajo**
  Future<void> _pullToRefresh() async {
     bovedaSupController.getBoveda(usuario.idPeaje ?? '0');
  }

  /// **Header: Usuario en sesión y total en bóveda**
  Widget _headerSection(BuildContext context) {
    final boveda = bovedaSupController.boveda.value;
    final totalBovedaFormatted = boveda?.total != null
        ? NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2).format(double.tryParse(boveda!.total!) ?? 0.0)
        : "Cargando...";

    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
        color: Color(0xFF368983),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  PopupMenuButton<int>(
                    child: CircleAvatar(
                      backgroundImage: usuario.imagen != null
                          ? NetworkImage(usuario.imagen!)
                          : AssetImage('assets/img/no-image.png') as ImageProvider,
                      radius: 20,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Ver Perfil'),
                          ],
                        ),
                        onTap: ()=> bovedaSupController.gotoProfile(),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Cerrar Sesión'),
                          ],
                        ),
                        onTap: ()=> bovedaSupController.signOut(),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Text(
                    usuario.nombre != null ? '${usuario.nombre} ${usuario.apellido}' : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              usuario.roles?.first.id =='1' || usuario.roles?.first.id =='5' ?
              Column(
                children: [
                  PopupMenuButton<int>(
                    icon: Image.asset('assets/img/peajee.png',height: 40.0,
                      width: 40.0,),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      usuario.idPeaje=='1'?
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.change_circle_outlined, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Los Angeles'),
                          ],
                        ),
                        onTap: ()=>bovedaSupController.actualizarPeaje(context,'2'),
                      ):
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.change_circle_outlined, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Congoma'),
                          ],
                        ),
                        onTap: ()=>bovedaSupController.actualizarPeaje(context,'1'),

                      ),
                    ],
                  ),
                  Text('${usuario.nombrePeaje}',style: TextStyle(color: Colors.white),)
                ],

              )
              :usuario.roles?.first.id =='2' ?
                  Column(
                    children: [
                      PopupMenuButton<int>(
                        icon: Image.asset('assets/img/fortius.png',height: 40.0,
                          width: 40.0,),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.monetization_on_outlined, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Depósito'),
                              ],
                            ),
                            onTap: ()=>bovedaSupController.goToRetiroFortius(usuario),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            child: Row(
                              children: [
                                Icon(Icons.change_circle_outlined, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Canje'),
                              ],
                            ),
                            onTap: ()=>bovedaSupController.goToCanjeFortius(usuario),

                          ),

                        ],
                      ),

                    ],

                  )
                :Column(),
            ],
          ),
          SizedBox(height: 20),

              Text(
                "Total en Bóveda",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                totalBovedaFormatted,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              usuario.roles?.first.id =='1' ?
              Column(
                children: [
                  PopupMenuButton<int>(
                    icon: Image.asset('assets/img/ajuste.png',height: 35.0,
                      width: 35.0,),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[

                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Modificar Boveda'),
                          ],
                        ),
                        onTap: ()=>bovedaSupController.goToModificarBoveda(boveda!),
                      ),

                    ],
                  ),
                ],

              )
                  :usuario.roles?.first.id =='2' ?
              Column(
                children: [
                  PopupMenuButton<int>(
                    icon: Image.asset('assets/img/reporte.png',height: 40.0,
                      width: 40.0,),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.request_page, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Recaudacion por turno'),
                          ],
                        ),
                        onTap: ()=>bovedaSupController.goToReporteRecaudaciones(usuario),

                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.local_atm, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Informe de Bóveda'),
                          ],
                        ),
                        onTap: ()=> bovedaSupController.goToInformeBoveda(boveda!,1),
                      ),
                    ],
                  ),
                ],
              ):usuario.roles?.first.id =='5' ?
              Column(
                children: [
                  PopupMenuButton<int>(
                    icon: Image.asset('assets/img/reporte.png',height: 40.0,
                      width: 40.0,),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[

                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.local_atm, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Informe de Bóveda'),
                          ],
                        ),
                        onTap: ()=> bovedaSupController.goToInformeBovedaActual(boveda!,1),
                      ),
                    ],
                  ),
                ],
              ):
              Column(
                children: [
                  PopupMenuButton<int>(
                    icon: Image.asset('assets/img/depositar.png',height: 40.0,
                      width: 40.0,),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.request_page, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Deposito venta TAG'),
                          ],
                        ),
                        onTap: ()=> Get.dialog(
                          AlertDialog(
                            title: Text("VENTA DE TAG"),
                            content: Text("Desea depositar el monto total de la venta de TAG?"),
                            actions: [
                              TextButton(
                                onPressed: ()=> {
                                  bovedaSupController.depositoBoveda(context,usuario.idPeaje??'1'),
                                },
                                child: Text("Si"),
                              ),
                              TextButton(
                                onPressed: (){ Navigator.of(context).pop(); },
                                child: Text("No"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }



  /// **Lista de denominaciones**
  Widget _denominacionesList(BuildContext context) {
    final boveda = bovedaSupController.boveda.value;


    if (boveda == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF368983)),
        ),
      );
    }

    // Crear una lista de denominaciones con etiquetas y valores
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);

    final denominaciones = [
      {
        "label": "\$20",
        "cantidad": int.tryParse(boveda.billete20 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.billete20 ?? "0") ?? 0) * 20.0),
        "icon": 'assets/img/billete.png'
      },
      {
        "label": "\$10",
        "cantidad": int.tryParse(boveda.billete10 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.billete10 ?? "0") ?? 0) * 10.0),
        "icon": 'assets/img/billete.png'
      },
      {
        "label": "\$5",
        "cantidad": int.tryParse(boveda.billete5 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.billete5 ?? "0") ?? 0) * 5.0),
        "icon": 'assets/img/billete.png'
      },
      {
        "label": "\$1",
        "cantidad": int.tryParse(boveda.moneda1 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.moneda1 ?? "0") ?? 0) * 1.0),
        "icon": 'assets/img/moneda.png'
      },
      {
        "label": "50¢",
        "cantidad": int.tryParse(boveda.moneda05 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.moneda05 ?? "0") ?? 0) * 0.50),
        "icon": 'assets/img/moneda.png'
      },
      {
        "label": "25¢",
        "cantidad": int.tryParse(boveda.moneda025 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.moneda025 ?? "0") ?? 0) * 0.25),
        "icon": 'assets/img/moneda.png'
      },
      {
        "label": "10¢",
        "cantidad": int.tryParse(boveda.moneda01 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.moneda01 ?? "0") ?? 0) * 0.10),
        "icon": 'assets/img/moneda.png'
      },
      {
        "label": "5¢",
        "cantidad": int.tryParse(boveda.moneda005 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.moneda005 ?? "0") ?? 0) * 0.05),
        "icon": 'assets/img/moneda.png'
      },
      {
        "label": "1¢",
        "cantidad": int.tryParse(boveda.moneda001 ?? "0") ?? 0,
        "valor": numberFormat.format((int.tryParse(boveda.moneda001 ?? "0") ?? 0) * 0.01),
        "icon": 'assets/img/moneda.png'
      },
    ];


    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: denominaciones.map((denominacion) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          denominacion['icon'] is String
                              ? Image.asset(
                            denominacion['icon'] as String? ?? '',// Ruta del asset
                            height: 40.0,
                            width: 40.0,
                          )
                              : Icon(
                            Icons.attach_money,
                            color: Color(0xFF368983),
                            size: 24.0,
                          ),
                          SizedBox(width: 8),
                          Text(
                            denominacion['label']as String? ?? '',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${denominacion['cantidad']} unidades',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          Text(
                            '\$${denominacion['valor']}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF368983)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconSettings(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10,bottom: 8),
        child: IconButton(
            onPressed: (){},
            icon: Icon(Icons.settings,color: Colors.white,
              size: 25,
            )),
      ),
    );
  }

}

