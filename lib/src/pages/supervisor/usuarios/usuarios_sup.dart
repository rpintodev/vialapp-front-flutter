import 'package:asistencia_vial_app/src/pages/supervisor/usuarios/usuarios_sup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/usuario.dart';

class UsuariosSup extends StatelessWidget {

  UsuariosSupController usuariosSupController = Get.put(UsuariosSupController());


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
              isScrollable: true,
              indicatorColor: Color(0xFF368983),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              tabs: List<Widget>.generate(4,(index){
                return Tab(
                    child: Text('Grupo ${index + 1}')
                );
              }),
            ),
          ),
        ),
        body: TabBarView(
          children: List<Widget>.generate(4, (index) {
            return FutureBuilder(
              future: usuariosSupController.getUsuariosGrupo((index + 1).toString()), // Cambia para manejar los grupos
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
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16.0,
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
            onPressed: ()=>usuariosSupController.gotoRegisterPage(),
            icon: Icon(Icons.person_add,color: Color(0xFF368983),
              size: 25,
            )),
      ),
    );
  }


  Widget _textFieldSearch(BuildContext context){
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width *0.7,
        child: TextField(
          decoration: InputDecoration(
              hintText: 'Buscar usuario',
              suffixIcon: Icon(Icons.search, color: Color(0xFF368983)),
              hintStyle: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF368983)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: Color(0xFF368983)
                  )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Colors.grey
                ),
              ),
              contentPadding: EdgeInsets.all(15)
          ),
        ),
      ),
    );
  }


}