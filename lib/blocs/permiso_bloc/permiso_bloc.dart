import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:residencias_app/repositories/permisos_repository.dart';
import 'package:residencias_app/blocs/permiso_bloc/permiso_event.dart';
import 'package:residencias_app/blocs/permiso_bloc/permiso_state.dart';
import 'package:residencias_app/utils/text_utils.dart';

export 'permiso_event.dart';
export 'permiso_state.dart';

class PermisoBloc extends Bloc<PermisoEvent, PermisoState> {
  final PermisosRepository _permisosRepository = new PermisosRepository();

  @override
  PermisoState get initialState => Inactivo();

  @override
  Stream<PermisoState> mapEventToState( PermisoEvent event ) async* {
    if(event is FindPermiso) {
      yield* _mapFindPermisoToState(event);
    } else if(event is AddOperacionControl) {
      yield* _mapAddOperacionPermisoToState(event);
    }
  }

  Stream<PermisoState> _mapFindPermisoToState(FindPermiso event) async* {
    print('RAW  ${event.permisoId}, ID: ${event.permisoId.substring(4)}');
    yield PermisoCargando();

    if(!event.permisoId.startsWith('key:')) {
      yield CodigoInvalido();
    } else {
      final permiso = await _permisosRepository.getPermisoById(event.permisoId.substring(4));
      print('PERMISO: $permiso');
      if(permiso == null) {
        yield PermisoNoEncontrado();
      } else if(!permiso.isOK) {
        yield PermisoNoAprobado();
      } else 
        yield PermisoEncontrado(permiso);
    }
  }

  Stream<PermisoState> _mapAddOperacionPermisoToState(AddOperacionControl event) async* {
    _permisosRepository.pushOperacionPermiso(event.permisoId, event.operacion);
  }
}
