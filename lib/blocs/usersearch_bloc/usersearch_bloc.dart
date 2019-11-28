import 'package:bloc/bloc.dart';
import 'package:residencias_app/blocs/usersearch_bloc/usersearch_event.dart';
import 'package:residencias_app/blocs/usersearch_bloc/usersearch_state.dart';
import 'package:residencias_app/models/usuario.dart';
import 'package:residencias_app/repositories/usuarios_repository.dart';
import 'package:residencias_app/utils/text_utils.dart';
import 'package:rxdart/rxdart.dart';

export 'usersearch_event.dart';
export 'usersearch_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final UsuariosRepository _userRepository = UsuariosRepository();
  List<Usuario> _queryResult = [];

  Stream<UserSearchState> transformEvents(
    Stream<UserSearchEvent> events,
    Stream<UserSearchState> Function(UserSearchEvent event) next,
  ) {
    return (events as Observable<UserSearchEvent>)
        .debounceTime(
          Duration(milliseconds: 300),
        )
        .switchMap(next);
    // final observableStream = events as Observable<UserSearchEvent>;
    // final nonDebounceStream = observableStream.where((event) {
    //   return (event is! QueryChanged);
    // });
    // final debounceStream = observableStream.where((event) {
    //   return (event is QueryChanged);
    // }).debounceTime(Duration(milliseconds: 300));

    // return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  UserSearchState get initialState => SearchStateEmpty();

  @override
  Stream<UserSearchState> mapEventToState( UserSearchEvent event ) async* {

    if(event is QueryChanged) {
      yield* _mapQueryChangedToState(event.query);
    }
  }

  Stream<UserSearchState> _mapQueryChangedToState(String query) async* {
    final parsQuery = query.trim().toLowerCase();

    if(parsQuery.isEmpty || parsQuery.length<3) {
      _queryResult = [];
      yield SearchStateEmpty();

    } else {
      
      if(parsQuery.length==9 && TextUtils.isNumeric(parsQuery)) {
        // BUSCAR POR CODIGO
        yield SearchStateLoading();
        //try catch
        final results = await _userRepository.searchResidenteByCodigo(parsQuery);
        yield SearchStateSuccess(results);

      } else if(TextUtils.isAllLetters(parsQuery)) {
        //BUSCAR POR NOMBRE
        yield SearchStateLoading();
        //try catch
        if(_queryResult.isEmpty) 
          _queryResult = await _userRepository.searchResidentesByNombre(parsQuery.substring(0,3));

        yield SearchStateSuccess( _searchInResults(_queryResult, parsQuery) );  
      } else
        yield SearchStateEmpty();
    }
  }

  

  List<Usuario> _searchInResults(List<Usuario> results, String query) {
    final words = TextUtils.splitIntoWords(query);

    return _queryResult.where(
      (user) => TextUtils.areNamesInText(' ${user.nombres} ${user.apellidos}'.toLowerCase(), words)
    ).toList();
  }
}