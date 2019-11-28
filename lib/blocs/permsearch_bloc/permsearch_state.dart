import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/permiso.dart';

abstract class PermSearchState extends Equatable {
  const PermSearchState();

  @override
  List<Object> get props => [];
}

class Inactivo extends PermSearchState {}

class PermisosResultado extends PermSearchState {
  final List<Permiso> permisos;

  const PermisosResultado(this.permisos);

  @override
  String toString() => 'PermisosLoaded { todos: $permisos }';
}

class PermisosCargando extends PermSearchState {}

class EntradaInvalida extends PermSearchState {}