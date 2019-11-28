import 'package:equatable/equatable.dart';
import 'package:residencias_app/models/usuario.dart';

abstract class UserSearchState extends Equatable {
  const UserSearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends UserSearchState {}

class SearchStateLoading extends UserSearchState {}

class SearchStateSuccess extends UserSearchState {
  final List<Usuario> users;

  const SearchStateSuccess(this.users);

  @override
  List<Object> get props => [users];

  @override
  String toString() => 'SearchStateSuccess { users: ${users.length} }';
}

// class SearchStateError extends UserSearchState {}