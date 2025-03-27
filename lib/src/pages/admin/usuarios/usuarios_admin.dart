import 'package:asistencia_vial_app/src/pages/admin/Usuarios/usuarios_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/rol.dart';
import '../../../models/usuario.dart';

class UsuariosAdmin extends StatelessWidget {

  UsuariosAdminController usuariosAdminController = Get.put(UsuariosAdminController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>DefaultTabController(
      length: usuariosAdminController.roles.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AppBar(
            flexibleSpace: Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  _textFieldSearch(context),
                  _iconAddUser()
                ],
              ),
            ),
            bottom: TabBar(

              tabAlignment: TabAlignment.center,
              isScrollable: true,
              indicatorColor: Color(0xFF368983),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              tabs: List<Widget>.generate(usuariosAdminController.roles.length,(index){
                return Tab(
                  child: Text(usuariosAdminController.roles[index].nombre??' '),
                );
              }),
            ),
          ),
        ),
        body: TabBarView(

          children: usuariosAdminController.roles.map<Widget>((Rol rol){
            return FutureBuilder(
                future: usuariosAdminController.getUsuarios(rol.id??'1'),
                builder: (context, AsyncSnapshot<List<Usuario>> snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data?.length??0,
                        itemBuilder: (_, index){
                          return _cardUsuario(context, snapshot.data![index],int.parse(rol.id??'1'));
                        }
                    );
                  }else{
                    return Container();
                  }
                }
            );
          }).toList(),
        ),
      ),
    ));
  }

  Widget _cardUsuario(BuildContext context, Usuario usuario, int cardIndex) {
    return GestureDetector(
      onTap: ()=> usuariosAdminController.openBottomSheet(context, usuario),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Margen entre tarjetas
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Sombra ligera
                blurRadius: 10, // Desenfoque
                offset: Offset(0, 5), // Desplazamiento de la sombra
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Espaciado interno
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Redondear la imagen
              child: FadeInImage(
                image: usuario.imagen != null
                    ? NetworkImage(usuario.imagen!)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeOutDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            title: Text(
              '${usuario.nombre} ${usuario.apellido}' ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              usuario.telefono ?? '',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.menu,
                color: Colors.grey[400],
                size: 16.0,
              ),
              itemBuilder: (BuildContext context) {
                return _getOptionsForCard(context, usuario, cardIndex); // Pasamos el índice de la tarjeta
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconAddUser(){
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: ()=>usuariosAdminController.gotoRegisterPage(),
              icon: Icon(Icons.person_add,color: Color(0xFF368983),
                size: 25,
              )),
        ),
    );
  }


  /// Método para obtener las opciones según el índice de la tarjeta
  List<PopupMenuEntry<String>> _getOptionsForCard(BuildContext context, Usuario usuario,int cardIndex) {
    switch (cardIndex) {
      case 1:
        return [
          PopupMenuItem<String>(
            value: "Actualizar",
            child: Row(
              children: [
                Icon(Icons.update, color: Colors.blue),
                SizedBox(width: 10),
                Text("Actualizar"),
              ],
            ),
            onTap: () => usuariosAdminController.goToActualizar(usuario)
          ),
          PopupMenuItem<String>(
            value: "Eliminar",
            child: Row(
              children: [
                Icon(Icons.delete_outline
                    , color: Colors.redAccent),
                SizedBox(width: 10),
                Text("Eliminar"),
              ],
            ),
            onTap: () {
              // Mostrar el cuadro de diálogo de confirmación
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showDeleteConfirmationDialog(context, usuario);
              });
            },
          ),

        ];
      case 2:
        return [
          PopupMenuItem<String>(
              value: "Actualizar",
              child: Row(
                children: [
                  Icon(Icons.update, color: Colors.blue),
                  SizedBox(width: 10),
                  Text("Actualizar"),
                ],
              ),
              onTap: () => usuariosAdminController.goToActualizar(usuario)
          ),
          PopupMenuItem<String>(
            value: "Eliminar",
            child: Row(
              children: [
                Icon(Icons.delete_outline
                    , color: Colors.redAccent),
                SizedBox(width: 10),
                Text("Eliminar"),
              ],
            ),
            onTap: () {
              // Mostrar el cuadro de diálogo de confirmación
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showDeleteConfirmationDialog(context, usuario);
              });
            },
          ),
        ];
      case 3:
        return [
          PopupMenuItem<String>(
              value: "Actualizar",
              child: Row(
                children: [
                  Icon(Icons.update, color: Colors.blue),
                  SizedBox(width: 10),
                  Text("Actualizar"),
                ],
              ),
              onTap: () => usuariosAdminController.goToActualizar(usuario)
          ),
          PopupMenuItem<String>(
            value: "Eliminar",
            child: Row(
              children: [
                Icon(Icons.delete_outline
                    , color: Colors.redAccent),
                SizedBox(width: 10),
                Text("Eliminar"),
              ],
            ),
            onTap: () {
              // Mostrar el cuadro de diálogo de confirmación
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showDeleteConfirmationDialog(context, usuario);
              });
            },
          ),
        ];
      default:
        return [
          PopupMenuItem<String>(
              value: "Actualizar",
              child: Row(
                children: [
                  Icon(Icons.update, color: Colors.blue),
                  SizedBox(width: 10),
                  Text("Actualizar"),
                ],
              ),
              onTap: () => usuariosAdminController.goToActualizar(usuario)
          ),
          PopupMenuItem<String>(
            value: "Eliminar",
            child: Row(
              children: [
                Icon(Icons.delete_outline
                    , color: Colors.redAccent),
                SizedBox(width: 10),
                Text("Eliminar"),
              ],
            ),
            onTap: () {
              // Mostrar el cuadro de diálogo de confirmación
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showDeleteConfirmationDialog(context, usuario);
              });
            },
          ),
        ];
    }
  }

  Widget _textFieldSearch(BuildContext context){
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width *0.6,
        alignment: Alignment.center,
        child: Text(
          'Usuarios',
          style: TextStyle(
            fontSize: 24, // Tamaño del texto
            fontWeight: FontWeight.bold, // Peso del texto
            color: Colors.black, // Color del texto
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text(
            "¿Estás seguro de que deseas eliminar al usuario ${usuario.nombre} ${usuario.apellido}?",
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
                usuariosAdminController.deleteUsuario(usuario.id??'1'); // Llama al método para eliminar el usuario
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }


}