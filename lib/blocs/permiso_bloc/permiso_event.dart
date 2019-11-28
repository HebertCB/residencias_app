import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/permiso.dart';

abstract class PermisoEvent extends Equatable {
  const PermisoEvent();

  @override
  List<Object> get props => [];
}

class FindPermiso extends PermisoEvent {
  final String permisoId;

  const FindPermiso(this.permisoId);

  @override
  List<Object> get props => [permisoId];
}

class AddOperacionControl extends PermisoEvent {
  final String permisoId;
  final Operacion operacion;

  const AddOperacionControl(this.permisoId, this.operacion);

  @override
  List<Object> get props => [permisoId, operacion];

  @override
  String toString() => 'AddOperacionPermiso { permisoId: $permisoId, operacion: $operacion }';
}


