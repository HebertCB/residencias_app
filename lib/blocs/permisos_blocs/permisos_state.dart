import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/permiso.dart';

abstract class PermisosState extends Equatable {
  const PermisosState();

  @override
  List<Object> get props => [];
}

class PermisosLoading extends PermisosState {}

class PermisosLoaded extends PermisosState {
  final List<Permiso> permisos;

  const PermisosLoaded(this.permisos);

  @override
  List<Object> get props => [permisos];

  @override
  String toString() => 'PermisosLoaded { todos: $permisos }';
}

// class PermisosNotLoaded extends PermisosState {}
