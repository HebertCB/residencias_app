import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/usuario.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final Usuario usuario;

  const Authenticated(this.usuario);

  @override
  List<Object> get props => [usuario];

  @override
  String toString() => 'Authenticated { microUser: $usuario}';
}

class Unauthenticated extends AuthState {}
