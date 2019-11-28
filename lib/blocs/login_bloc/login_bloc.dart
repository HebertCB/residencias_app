import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:residencias_app/blocs/login_bloc/login_event.dart';
import 'package:residencias_app/blocs/login_bloc/login_state.dart';
import 'package:residencias_app/repositories/auth_repository.dart';
import 'package:residencias_app/utils/validators.dart';

export 'login_event.dart';
export 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  final AuthRepository _authRepository = new AuthRepository();

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if(event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if(event is Submitted) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: '${event.email}@upeu.edu.pe',
        password: event.password
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState( String email ) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState( String password ) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({ String email, String password }) async*{
    yield LoginState.loading();
    try{
      await _authRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch(_) {
      yield LoginState.failure();
    }
  }
}
