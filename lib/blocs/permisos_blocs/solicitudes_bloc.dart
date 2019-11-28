import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:residencias_app/repositories/permisos_repository.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_event.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_state.dart';

export 'permisos_event.dart';
export 'permisos_state.dart';

class SolicitudesBloc extends Bloc<PermisosEvent, PermisosState> {
  final PermisosRepository _permisosRepository = new PermisosRepository();
  StreamSubscription _permisosSubscription;

  @override
  PermisosState get initialState => PermisosLoading();

  @override
  Stream<PermisosState> mapEventToState( PermisosEvent event ) async* {
    if(event is LoadPermisos) {
      yield* _mapLoadPermisosToState();
    } else if(event is AprobacionPermiso) {
      yield* _mapAprobacionPermisoToState(event);
    } else if(event is AddOperacionPermiso) {
      yield* _mapAddOperacionPermisoToState(event);
    } else if(event is DeletePermiso) {
      yield* _mapDeletePermisoToState(event);
    } else if(event is PermisosUpdated) {
      yield* _mapPermisosUpdatedToState(event);
    }
  }

  Stream<PermisosState> _mapLoadPermisosToState() async* {
    _permisosSubscription?.cancel();
    _permisosSubscription = _permisosRepository.getTodasSolicitudes().listen(
      (permisos) => add(PermisosUpdated(permisos)),
    );
  }

  Stream<PermisosState> _mapAddOperacionPermisoToState(AddOperacionPermiso event) async* {
    _permisosRepository.pushOperacionPermiso(event.permisoId, event.operacion);
  }

  Stream<PermisosState> _mapAprobacionPermisoToState(AprobacionPermiso event) async* {
    _permisosRepository.pushOperacionAprobar(event.permisoId, event.operacion);
  }

  Stream<PermisosState> _mapPermisosUpdatedToState(PermisosUpdated event) async* {
    yield PermisosLoaded(event.permisos);
  }

  Stream<PermisosState> _mapDeletePermisoToState(DeletePermiso event) async* {
    _permisosRepository.deletePermiso(event.permisoId);
  }

  @override
  Future<void> close() {
    _permisosSubscription?.cancel();
    return super.close();
  }
}
