import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_event.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_state.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/repositories/auth_repository.dart';
import 'package:residencias_app/repositories/usuarios_repository.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository _authRepository = AuthRepository();
  final UsuariosRepository _usuariosRepository = UsuariosRepository();

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState( AuthEvent event ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final userId = await _authRepository.getUserId();
        final user = await _usuariosRepository.getUser(userId);
        yield Authenticated(user);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final userId = await _authRepository.getUserId();
    final user = await _usuariosRepository.getUser(userId);
    yield Authenticated(user);
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _authRepository.signOut();
  }
}
