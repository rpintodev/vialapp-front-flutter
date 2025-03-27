import 'package:asistencia_vial_app/src/pages/supervisor/usuarios/usuarios_sup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';

class UsuariosSup extends StatelessWidget {

  UsuariosSupController usuariosSupController = Get.put(UsuariosSupController());
  List<String> groupLabels = ['A', 'B', 'C', 'D', 'E'];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
                  _iconAddUser(),
                  _iconAsignar(),
                ],
              ),
            ),
            bottom: TabBar(
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              indicatorColor: Color(0xFF368983),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              onTap: (index) {
                usuariosSupController.updateTabIndex(index);
              },

            tabs: List<Widget>.generate(5, (index) {
              return Tab(
                child: Text('Grupo ${groupLabels[index]}'),
              );
            }),
            ),
          ),
        ),
        body: TabBarView(
          children: List<Widget>.generate(5, (index2) {
            return FutureBuilder(
              future: usuariosSupController.getUsuariosGrupo((index2 + 1).toString(),usuariosSupController.usuarioSession.idPeaje??'1'), // Cambia para manejar los grupos
              builder: (context, AsyncSnapshot<List<Usuario>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      return _cardUsuario(context, snapshot.data![index]);
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _cardUsuario(BuildContext context, Usuario usuario) {
    return GestureDetector(
      onTap: ()=> usuariosSupController.openBottomSheet(context, usuario),

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
                Icons.more_vert,
                color: Colors.grey[400],
                size: 20.0,
              ),

              itemBuilder: (BuildContext context) => _getPopupMenuItems(context,usuario),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconAddUser(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 1),
        child: IconButton(
            onPressed: ()=>usuariosSupController.gotoRegisterPage(),
            icon: Icon(Icons.person_add,color: Color(0xFF368983),
              size: 25,
            )),
      ),
    );
  }

  Widget _iconAsignar() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 1),
        child: IconButton(
          onPressed: () async {
            int groupIndex = usuariosSupController.currentTabIndex.value;

            // Carga los usuarios del grupo antes de mostrar el cuadro de diálogo
            await usuariosSupController.loadUsuariosGrupoActual(groupIndex,usuariosSupController.usuarioSession.idPeaje??'1');

            _showAssignDialog(groupIndex);
          },
          icon: Icon(
            Icons.fact_check,
            color: Color(0xFF368983),
            size: 25,
          ),
        ),
      ),
    );
  }


  void _showAssignDialog(int groupIndex) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Asignar Turno', style: TextStyle(color: Colors.black),),
          content: Text('¿Deseas asignar todo el Grupo ${groupIndex}?',style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: ()  {
                usuariosSupController.asignarTurnoLote(context);

                // Cierra el cuadro de diálogo
                Navigator.of(context).pop();
              },
              child: Text('Asignar'),
            ),
          ],
        );
      },
    );
  }




  List<PopupMenuEntry<String>> _getPopupMenuItems(BuildContext context, Usuario usuario) {
    return [
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(Icons.work_history, color: Colors.green),
            SizedBox(width: 10),
            Text("Asignar Turno"),
          ],
        ),
          onTap: () => usuariosSupController.asignarTuno(context, usuario)
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(Icons.update, color: Colors.blue),
            SizedBox(width: 10),
            Text("Actualizar Perfil"),
          ],
        ),
          onTap: () => usuariosSupController.goToActualizar(usuario)
      ),

    ];
  }

  Widget _textFieldSearch(BuildContext context){
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width *0.6,
        alignment: Alignment.center,
        child: Text(
          'Cajeros',
          style: TextStyle(
            fontSize: 24, // Tamaño del texto
            fontWeight: FontWeight.bold, // Peso del texto
            color: Colors.black, // Color del texto
          ),
        ),
      ),
    );
  }


}