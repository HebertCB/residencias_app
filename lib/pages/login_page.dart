import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/blocs/login_bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;  

  bool get _isPopulated =>
    _emailController.text.trim().isNotEmpty && _emailController.text.trim().isNotEmpty;

  bool _isLoginButtonEnabled(LoginState state) =>
    state.isFormValid && _isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc,LoginState>(
      listener: (context, state) {
        if(state.isFailure) {
          _showSnackBar('Correo o contraseña incorrecta', Icon(Icons.error), Colors.red);
        } else if(state.isSubmitting) {
          _showSnackBar('Verificando credenciales...', CircularProgressIndicator(), null);
        } else if(state.isSuccess) {
            BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context,state) {
          return ListView(
              children: <Widget>[
                _crearFondo(),
                _crearCampoEmail(state),
                _crearCampoPassword(state),
                SizedBox(height: 10.0,),
                _crearBotonSubmit(state),
              ],
          );
        }
      )
    );
  }

  void _showSnackBar(String text, Widget trailing, Color color) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 15),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(text),
              trailing
            ],
          ),
          backgroundColor: color,
        )
      );
  }

  Widget _crearFondo() {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height*0.4,
      width: double.infinity,
      color: Theme.of(context).accentColor,
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, right: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: -10.0, child: circulo ),      
        Positioned( bottom: 100.0, right: 20.0, child: circulo ),
        Positioned( bottom: -50.0, left: -20.0, child: circulo ),

        Positioned.fill(
            // alignment: Alignment.bottomLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  Icon(Icons.person_pin, color: Colors.white, size: 100.0),
                  SizedBox(height: 10.0, width: double.infinity),
                  Text('Residencias Upeu', style: TextStyle(color: Colors.white, fontSize: 25.0) ),
                ],
              ),
          ),
      ],
    );
  }

  Widget _crearCampoEmail(LoginState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail_outline),
          hintText: 'Correo electrónico',
          suffixText: '@upeu.edu.pe',
          errorText: !state.isEmailValid ?'Email inválido':null,
        ),
      ),
    );
  }

  Widget _crearCampoPassword(LoginState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline),
          hintText: 'Contraseña',
          errorText: !state.isPasswordValid ?'Contraseña inválido':null,
        ),
      ),
    );
  }

  Widget _crearBotonSubmit(LoginState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: Text('Ingresar'),
        onPressed: _isLoginButtonEnabled(state)
                   ? _onFormSubmitted
                   : null,
      ),
    );
  }

  void _onEmailChanged() {
    _loginBloc.add( EmailChanged(email: _emailController.text) );
  }
  
  void _onPasswordChanged() {
    _loginBloc.add( PasswordChanged(password: _passwordController.text) );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      )
    );
  }
}