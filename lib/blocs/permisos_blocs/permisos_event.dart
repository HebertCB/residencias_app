import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/permiso.dart';

abstract class PermisosEvent extends Equatable {
  const PermisosEvent();

  @override
  List<Object> get props => [];
}

class LoadPermisos extends PermisosEvent {}

class AddPermiso extends PermisosEvent {
  final Permiso permiso;

  const AddPermiso(this.permiso);

  @override
  List<Object> get props => [permiso];

  @override
  String toString() => 'AddPermiso { permiso: $permiso }';
}

class AddOperacionPermiso extends PermisosEvent {
  final String permisoId;
  final Operacion operacion;

  const AddOperacionPermiso(this.permisoId, this.operacion);

  @override
  List<Object> get props => [permisoId, operacion];

  @override
  String toString() => 'AddOperacionPermiso { permisoId: $permisoId, operacion: $operacion }';
}

class AprobacionPermiso extends PermisosEvent {
  final String permisoId;
  final Operacion operacion;

  const AprobacionPermiso(this.permisoId, this.operacion);

  @override
  List<Object> get props => [permisoId, operacion];

  @override
  String toString() => 'AprobacionPermiso { permisoId: $permisoId, operacion: $operacion }';
}

class DeletePermiso extends PermisosEvent {
  final String permisoId;

  const DeletePermiso(this.permisoId);

  @override
  List<Object> get props => [permisoId];

  @override
  String toString() => 'DeletePermiso { permisoId: $permisoId }';
}

class PermisosUpdated extends PermisosEvent {
  final List<Permiso> permisos;

  const PermisosUpdated(this.permisos);

  @override
  List<Object> get props => [permisos];
}


