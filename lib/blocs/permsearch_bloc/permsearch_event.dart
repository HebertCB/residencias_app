import 'package:equatable/equatable.dart';
// import 'package:residencias_app/models/permiso.dart';

abstract class PermSearchEvent extends Equatable {
  const PermSearchEvent();

  // @override
  // List<Object> get props => [];
}

class FindPermisoCodigo extends PermSearchEvent {
  final String codigo;

  const FindPermisoCodigo(this.codigo);

  @override
  List<Object> get props => [codigo];
}
