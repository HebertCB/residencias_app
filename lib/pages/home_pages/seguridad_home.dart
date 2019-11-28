import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/permiso_bloc/permiso_bloc.dart';
import 'package:residencias_app/blocs/permsearch_bloc/permsearch_bloc.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/pages/permiso_search.dart';
import 'package:residencias_app/pages/views/button_view.dart';
import 'package:residencias_app/pages/views/miperfil_view.dart';

class SeguridadHome extends StatefulWidget {
  const SeguridadHome({Key key}) : super(key: key);

  @override
  _SeguridadHomeState createState() => _SeguridadHomeState();
}

class _SeguridadHomeState extends State<SeguridadHome> {
  int _viewIndex = 0;  
  final List<Widget> _views = [
    ButtonView(),
    MiPerfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_crearTitulo()),
        actions: _viewIndex==0 ? <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: PermisoSearch(PermSearchBloc()),     
              );
              if(result!=null)
                Navigator.pushNamed(context, 'detailPage', arguments: [
                  result as Permiso,
                  Acciones.seguridad,
                  BlocProvider.of<PermisoBloc>(context)
                ]);
            },
          )
        ]
        : []
      ),
      body: _views.elementAt(_viewIndex),
      bottomNavigationBar: _crearBottomNavBar(),
    );
  }

  String _crearTitulo() {
    switch(_viewIndex) {
      case 0: return 'Buscar';
      default: return 'Mi perfil';
    }
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
          icon: Icon(Icons.search),
          title: Text('Buscar')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          title: Text('Mi Perfil')
        ),
      ],
    );
  }
}
