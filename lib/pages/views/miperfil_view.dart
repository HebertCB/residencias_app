import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/models/usuario.dart';

class MiPerfilView extends StatelessWidget {
  // final UsuariosRepository _usuariosRepository = new UsuariosRepository();

  const MiPerfilView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = (BlocProvider.of<AuthBloc>(context).state as Authenticated).usuario;

    return ListView(
      children: <Widget>[
        _crearPerfil(currentUser),
        ListTile(
          title: Text('Configuración'),
          onTap: (){},
        ),
        ListTile(
          title: Text('Cerrar sesión'),
          onTap: (){
            BlocProvider.of<AuthBloc>(context).add(LoggedOut());
            Navigator.pushReplacementNamed(context, 'login');
          },
        )
      ],
    );
  }

  Widget _crearPerfil(Usuario user) {
    return Container(
      color: Colors.black12,
      padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,             
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: 54.0,
          ),
          SizedBox(height: 5.0),
          Text('${user.nombres} ${user.apellidos}\n'
          '${user.codigo} \n(${user.rol})')
        ],
      ),
    );
  }
}