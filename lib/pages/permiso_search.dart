import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/permsearch_bloc/permsearch_bloc.dart';
import 'package:residencias_app/widgets/loading_indicator.dart';

class PermisoSearch extends SearchDelegate {
  
  final PermSearchBloc permisoSearchBloc;

  PermisoSearch(this.permisoSearchBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
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
    permisoSearchBloc.add( FindPermisoCodigo(query) );

    return BlocBuilder(
      bloc: permisoSearchBloc,
      builder: (BuildContext context, PermSearchState state) {
        print(state);
        if (state is PermisosCargando) {
          return LoadingIndicator();
        } else if(state is PermisosResultado) {
          if(state.permisos.isEmpty) return Text('No se encontraron resultados.');
          return ListView.builder(
            itemCount: state.permisos.length,
            itemBuilder: (context, index) {
              final permiso = state.permisos[index];
              return ListTile(
                leading: CircleAvatar(),
                title: Text('${permiso.residenteNombre}'),
                subtitle: Text('${permiso.lugar}, ${permiso.motivo}'),
                onTap: () => close(context, permiso),
              );
            },
          );
        } else if(state is EntradaInvalida) {
          return Text('La entrada no es válida.');
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('Ingrese el codigo completo del estudiante.');
  }

  @override
  void close(BuildContext context, result) {
    permisoSearchBloc.close();
    super.close(context, result);
  }

  @override
  String get searchFieldLabel => 'Código de estudiante';
}