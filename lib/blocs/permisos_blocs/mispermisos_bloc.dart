import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:residencias_app/repositories/permisos_repository.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_event.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_state.dart';

export 'permisos_event.dart';
export 'permisos_state.dart';

class MisPermisosBloc extends Bloc<PermisosEvent, PermisosState> {
  final PermisosRepository _permisosRepository = new PermisosRepository();
  final String _userId;
  StreamSubscription _permisosSubscription;

  MisPermisosBloc({ @required String userId }) : _userId = userId;

  @override
  PermisosState get initialState => PermisosLoading();

  @override
  Stream<PermisosState> mapEventToState( PermisosEvent event ) async* {
    if(event is LoadPermisos) {
      yield* _mapLoadPermisosToState();
    } else if(event is AddPermiso) {
      yield* _mapAddPermisoToState(event);
    } else if(event is PermisosUpdated) {
      yield* _mapPermisosUpdatedToState(event);
    }
  }

  Stream<PermisosState> _mapLoadPermisosToState() async* {
    _permisosSubscription?.cancel();
    _permisosSubscription = _permisosRepository.getMisPermisos(_userId).listen(
      (permisos) => add(PermisosUpdated(permisos)),
    );
  }

  Stream<PermisosState> _mapAddPermisoToState(AddPermiso event) async* {
    _permisosRepository.addNewPermiso(event.permiso);
  }

  Stream<PermisosState> _mapPermisosUpdatedToState(PermisosUpdated event) async* {
    yield PermisosLoaded(event.permisos);
  }

  @override
  Future<void> close() {
    _permisosSubscription?.cancel();
    return super.close();
  }
}
