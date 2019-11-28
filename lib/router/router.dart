import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/blocs/login_bloc/login_bloc.dart';
import 'package:residencias_app/blocs/permiso_bloc/permiso_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/mispermisos_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/solicitudes_bloc.dart';
import 'package:residencias_app/pages/add_page.dart';
import 'package:residencias_app/pages/detail_page.dart';
import 'package:residencias_app/pages/login_page.dart';
import 'package:residencias_app/pages/home_pages/preceptor_home.dart';
import 'package:residencias_app/pages/home_pages/residente_home.dart';
import 'package:residencias_app/pages/home_pages/seguridad_home.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:bloc/bloc.dart';


class Router {

  Route<LoginPage> _loginPage() {
    return MaterialPageRoute(
      builder: (context) =>
        BlocListener<AuthBloc,AuthState>(
          listener: (context, state) {
            if(state is Authenticated)
              Navigator.pushReplacementNamed(context, '${state.usuario.rol}Home',arguments: state.usuario.key);
            else
              Navigator.pushReplacementNamed(context, 'login');
          },
          child: BlocProvider(
            builder: (context) => LoginBloc(),
            child: LoginPage(),
          ),
        )
    );
  }

  Route<ResidenteHome> _residenteHome(String userId) {
    return MaterialPageRoute(
      builder: (context) => 
        BlocProvider(
          builder: (context) => MisPermisosBloc(userId: userId)..add(LoadPermisos()),
          child: ResidenteHome()
        )
    );
  }

  // Route<ResidenteHome> _homePage() {
  //   return MaterialPageRoute(
  //     builder: (context) => ResidenteHome()
  //   );
  // }

  Route<PreceptorHome> _preceptorHome() {
    return MaterialPageRoute(
      builder: (context) =>        
        MultiBlocProvider(
          providers: [
            BlocProvider<PermisosBloc>(
              builder: (context) => PermisosBloc()..add(LoadPermisos())
            ),
            BlocProvider<SolicitudesBloc>(
              builder: (context) => SolicitudesBloc()..add(LoadPermisos())
            ),
          ],
          child: PreceptorHome()
        )
    );
  }

  Route<SeguridadHome> _seguridadHome() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        builder: (context) => PermisoBloc(),
        child: SeguridadHome(),
      )
    );
  }

  Route<AddPage> _addPage(List<dynamic> args) {
    final onSave = (args[0] as Function);
    final residenteObj = args.length>1 ? (args[1] as ResidenteObj) : null;
    return MaterialPageRoute(
      builder: (context) => AddPage(onSave: onSave, residenteObj: residenteObj,)
    );
  }

  Route<AddPage> _detailPage(List<dynamic> args) {
    final permiso = (args[0] as Permiso);
    final actions = args.length>1 ? (args[1] as Acciones) : null;
    final bloc = args.length>2 ? (args[2] as Bloc) : null;
    return MaterialPageRoute(
      builder: (context) => DetailPage(item: permiso, actions: actions, bloc: bloc,)
    );
  }

  Route _notFoundPage() {
    return MaterialPageRoute(
      builder: (context) => Center(child: Text('Página no encontrada.')),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case 'login':         return _loginPage();
      case 'residenteHome': return _residenteHome(settings.arguments as String);
      case 'preceptorHome': return _preceptorHome();
      case 'seguridadHome': return _seguridadHome();
      // case 'homePage':      return _homePage();
      case 'addPage':       return _addPage(settings.arguments as List<dynamic>);
      case 'detailPage':    return _detailPage(settings.arguments as List<dynamic>);
      default: return _notFoundPage();
    }
  }
}