import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/pages/Detalle/detalle_usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalleUsuario extends StatelessWidget {

  Usuario? usuario;

   late DetalleUsuarioController detalleUsuarioController;

  DetalleUsuario({@required this.usuario}){
      detalleUsuarioController=Get.put(DetalleUsuarioController(usuario!));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Modal ocupa el 60% de la pantalla
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          _infoCard(context),
        ],
      ),
    );
  }

  /// **Widget: Imagen de Usuario**


  Widget _infoCard(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Imagen del usuario pequeña
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    image: usuario?.imagen != null
                        ? NetworkImage(usuario!.imagen!)
                        : AssetImage('assets/img/no-image.png') as ImageProvider,
                    placeholder: AssetImage('assets/img/no-image.png'),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15),
                // Nombre del usuario al lado de la imagen
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${usuario?.nombre} ${usuario?.apellido}' ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        usuario?.usuario ?? 'No registrado',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espaciado entre filas
            _textInfo('Teléfono', usuario?.telefono ?? 'No registrado', Icons.phone),
            _textInfo('Rol', usuario?.nombreRol ?? 'No registrado', Icons.work),
            _textInfo('Peaje', usuario?.nombrePeaje ?? 'No registrado', Icons.gps_fixed),
            SizedBox(height: 20), // Espaciado antes de los botones
          ],
        ),
      ),
    );
  }

  /// **Widget: Texto de Información**
  Widget _textInfo(String label, String value,IconData icono) {
    return Container(

        padding: const EdgeInsets.symmetric(vertical:0),
        child: ListTile(
          leading: Icon(icono,color: Color(0xFF368983),),
          title: Text('$value' ??'',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,

            ),),
          subtitle:  Text('$label',
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )

          ),

        )
    );
  }

  /// **Widget: Texto de Nombres**
  Widget _textNombres() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10,bottom: 1,left: 15),
      child: Text(
        '${usuario?.nombre} ${usuario?.apellido}' ?? '',
        style: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



  /// **Widget: Botón Personalizado**
  Widget _customButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

