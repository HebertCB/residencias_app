import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_bloc.dart';
import 'package:residencias_app/blocs/usersearch_bloc/usersearch_bloc.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/models/usuario.dart';
import 'package:residencias_app/pages/residente_search.dart';
import 'package:residencias_app/pages/views/miperfil_view.dart';
import 'package:residencias_app/pages/views/permisos_view.dart';
import 'package:residencias_app/pages/views/solicitudes_view.dart';

class PreceptorHome extends StatefulWidget {

  const PreceptorHome({Key key}) : super(key: key);

  @override
  _PreceptorHomeState createState() => _PreceptorHomeState();
}

class _PreceptorHomeState extends State<PreceptorHome> {
  int _viewIndex = 0;
  final List<Widget> _views = [
    SolicitudesView(),
    PermisosView(),
    MiPerfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_crearTitulo()),
      ),
      body: _views.elementAt(_viewIndex),
      floatingActionButton: _viewIndex==1?_crearAddFab():null,
      bottomNavigationBar: _crearBottomNavBar(),
    );
  }

  String _crearTitulo() {
    switch(_viewIndex) {
      case 0: return 'Solicitudes';
      case 1: return 'Permisos';
      default: return 'Mi perfil';
    }
  }

  Widget _crearAddFab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        final result = await showSearch(
          context: context,
          delegate: ResidenteSearch(UserSearchBloc()),        
        );
        if(result!=null)
          Navigator.pushNamed(context, 'addPage', arguments: [
            _crearPermisoFunc(),
            _residentObjFromUser(result as Usuario)
          ]);
      },
    );
  }

  OnCreateCallBack _crearPermisoFunc() {
    return (lugar, motivo, fsalida, fentrada, parentescoap, ncelular ,comentarios, objetivo) {
      final currentUser = (BlocProvider.of<AuthBloc>(context).state as Authenticated).usuario;
      BlocProvider.of<PermisosBloc>(context).add(
        AddPermiso( Permiso(
          objetivo.residenteId,
          objetivo.residenteNombre,
          objetivo.residenteCodigo,
          lugar, motivo, fsalida, fentrada, parentescoap, ncelular, comentarios,
          operaciones: [Operacion('${currentUser.nombres} ${currentUser.apellidos}')],
          isOK: true,
        ))
      );
    };
  }

  ResidenteObj _residentObjFromUser(Usuario user) {
    return ResidenteObj(user.key, '${user.nombres} ${user.apellidos}', user.codigo);
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
          icon: Icon(Icons.access_time),
          title: Text('Solicitudes')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_open),
          title: Text('Permisos')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          title: Text('Mi Perfil')
        ),
      ],
    );
  }
}