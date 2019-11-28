import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:residencias_app/repositories/permisos_repository.dart';
import 'package:residencias_app/blocs/permsearch_bloc/permsearch_event.dart';
import 'package:residencias_app/blocs/permsearch_bloc/permsearch_state.dart';
import 'package:residencias_app/utils/text_utils.dart';

export 'permsearch_event.dart';
export 'permsearch_state.dart';

class PermSearchBloc extends Bloc<PermSearchEvent, PermSearchState> {
  final PermisosRepository _permisosRepository = new PermisosRepository();

  @override
  PermSearchState get initialState => Inactivo();

  @override
  Stream<PermSearchState> mapEventToState( PermSearchEvent event ) async* {
    if(event is FindPermisoCodigo) {
      yield* _mapAFindPermisoCodigoToState(event);
    }
  }

  Stream<PermSearchState> _mapAFindPermisoCodigoToState(FindPermisoCodigo event) async* {
    if( !TextUtils.isNumeric(event.codigo.trim() ) ) { yield EntradaInvalida();
    } else {
      yield PermisosCargando();
      
      final parsCodigo = int.parse(event.codigo.trim());
      final permisos = await _permisosRepository.getPermisosByCodigo(parsCodigo);
      yield PermisosResultado(permisos);
    }
  }
}
