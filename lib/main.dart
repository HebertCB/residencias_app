import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/router/router.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final Router router = new Router();

    return BlocProvider(
      builder: (context) => AuthBloc()..add(AppStarted()),
      child: MaterialApp(
        title: 'Residencias App',
        home: 
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is Authenticated)
                Navigator.pushReplacementNamed(context, '${state.usuario.rol}Home',arguments: state.usuario.key);
              else
                Navigator.pushReplacementNamed(context, 'login');
            },
            child: Scaffold( body: Center(child: FlutterLogo(size: 64.0,)) ),
          ),
        // home: BlocListener(),
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}