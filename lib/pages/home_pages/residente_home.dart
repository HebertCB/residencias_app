import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/mispermisos_bloc.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/pages/views/miperfil_view.dart';
import 'package:residencias_app/pages/views/mispermisos_view.dart';

class ResidenteHome extends StatefulWidget {

  ResidenteHome({Key key}) : super(key: key);

  @override
  _ResidenteHomeState createState() => _ResidenteHomeState();
}

class _ResidenteHomeState extends State<ResidenteHome> {
  int _viewIndex = 0;  
  final List<Widget> _views = [
    MisPermisosView(),
    MiPerfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_crearTitulo()),
      ),
      body: _views.elementAt(_viewIndex),
      floatingActionButton: _viewIndex==0?_crearAddFab():null,
      bottomNavigationBar: _crearBottomNavBar(),
    );
  }

  String _crearTitulo() {
    switch(_viewIndex) {
      case 0: return 'Mis permisos';
      default: return 'Mi perfil';
    }
  }

  Widget _crearAddFab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, 'addPage', arguments: [_crearPermisoFunc()]);
      },
    );
  }

  OnCreateCallBack _crearPermisoFunc() {
    return (lugar, motivo, fsalida, fentrada, parentescoap, ncelular ,comentarios, objetivo) {
      final currentUser = (BlocProvider.of<AuthBloc>(context).state as Authenticated).usuario;
      BlocProvider.of<MisPermisosBloc>(context).add(
        AddPermiso( Permiso(
          currentUser.key,
          '${currentUser.nombres} ${currentUser.apellidos}',
          currentUser.codigo,
          lugar, motivo, fsalida, fentrada, parentescoap, ncelular, comentarios
        ))
      );
    };
  }

  Widget _crearBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _viewIndex,
      onTap: (index) {
        setState(() {
          _viewIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_open),
          title: Text('Mis permisos')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          title: Text('Mi Perfil')
        ),
      ],
    );
  }
}