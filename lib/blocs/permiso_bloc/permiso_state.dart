import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/permiso.dart';

abstract class PermisoState extends Equatable {
  const PermisoState();

  @override
  List<Object> get props => [];
}

class Inactivo extends PermisoState {}

class PermisoCargando extends PermisoState {}

class PermisoEncontrado extends PermisoState {
  final Permiso permiso;

  const PermisoEncontrado(this.permiso);

  @override
  List<Object> get props => [permiso];

  @override
  String toString() => 'PermisosLoaded { todos: $permiso }';
}

class PermisoNoEncontrado extends PermisoState {}

class PermisoNoAprobado extends PermisoState {}

class CodigoInvalido extends PermisoState {}
