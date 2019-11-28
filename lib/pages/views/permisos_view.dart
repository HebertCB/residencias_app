import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_bloc.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/utils/date_utils.dart';
import 'package:residencias_app/widgets/loading_indicator.dart';

class PermisosView extends StatelessWidget {
  const PermisosView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermisosBloc, PermisosState>(
      builder: (context, state) {
        if(state is PermisosLoading){
          return LoadingIndicator();
        } else if(state is PermisosLoaded) {
          return _crearLista(state.permisos);
        } else {
          return Center(child: Text('(!) Ocurrió un error al cargar.'));
        }
      },
    );
  }

  Widget _crearLista(List<Permiso> lista) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final permiso = lista[index];
        return _crearPermisoItem(permiso, onTap: () {
          Navigator.pushNamed(context,'detailPage', arguments: [permiso, Acciones.preceptor, BlocProvider.of<PermisosBloc>(context)]);
        });                
      },
    );
  }

  Widget _crearPermisoItem(Permiso permiso, {@required Function onTap}) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(permiso.residenteNombre),
      subtitle: Text(_getSalida(permiso)),
      trailing: Chip( label: Text(_getEstado(permiso.operaciones)),),
      onTap: onTap,
    );
  }  

  String _getEstado(List<Operacion> operaciones) {
    switch(operaciones.length) {
      case 1: return 'Por salir';
      case 2: return 'Ha salido';
      case 3: return 'Ha vuelto';
      default: return 'Culminado';
    }
  }

  String _getSalida(Permiso permiso) {
    if(permiso.operaciones.length<2) {
      if(DateUtils.esHoy(permiso.fsalida))
        return 'Sale hoy';
      else
        return 'Sale el ${DateUtils.formatDate(permiso.fsalida)}';
    } else
      if(permiso.operaciones.length < 3 ) {
        if(DateUtils.esHoy(permiso.fentrada))
          return 'Regresa hoy';
        else
          return 'Regresa el ${DateUtils.formatDate(permiso.fsalida)}';
      } else 
        if(permiso.operaciones.length < 4) {
          return 'Ha regresado';
        } else {
          return 'Culminado';
        }
  }

}