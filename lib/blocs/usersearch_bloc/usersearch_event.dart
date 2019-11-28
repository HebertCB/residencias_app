import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UserSearchEvent extends Equatable {
  const UserSearchEvent();
}

class QueryChanged extends UserSearchEvent {
  final String query;

  const QueryChanged(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'QueryChanged { query: $query }';
}

