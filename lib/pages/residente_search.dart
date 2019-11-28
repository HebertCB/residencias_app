import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/usersearch_bloc/usersearch_bloc.dart';
import 'package:residencias_app/widgets/loading_indicator.dart';

class ResidenteSearch extends SearchDelegate {
  
  final UserSearchBloc usersearchBloc;

  ResidenteSearch(this.usersearchBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          usersearchBloc.add(QueryChanged(''));
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    // return BlocBuilder(
    //   bloc: usersearchBloc,
    //   builder: (BuildContext context, UserSearchState state) {
    //     if (state is SearchStateLoading) {
    //       return LoadingIndicator();
    //     } else
    //     return ListView.builder(
    //       itemCount: state.users.length,
    //       itemBuilder: (context, index) {
    //         final user = state.users[index];
    //         return ListTile(
    //           leading: CircleAvatar(),
    //           title: Text('${user.nombres} ${user.apellidos}'),
    //           subtitle: Text(user.codigo.toString()),
    //           onTap: () => close(context, user),
    //         );
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    usersearchBloc.add(QueryChanged(query));
  
    return BlocBuilder(
      bloc: usersearchBloc,
      builder: (BuildContext context, UserSearchState state) {
        if (state is SearchStateLoading) {
          return LoadingIndicator();
        } else if (state is SearchStateSuccess) {
          return state.users.isEmpty
            ? Text('No se encontraron resultados.')
            : ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(),
                  title: Text('${user.nombres} ${user.apellidos}'),
                  subtitle: Text('${user.codigo}'),
                  onTap: () { 
                    close(context, user);
                  },
                );
              },
            );
        }
        return Text('Debes ingresar por lo menos mas de 3 letras.');
      },
    );
  } 

  @override
  void close(BuildContext context, result) {
    usersearchBloc.close();
    super.close(context, result);
  }

  @override
  String get searchFieldLabel => 'Nombre o código';
}