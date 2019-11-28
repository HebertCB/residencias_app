import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/solicitudes_bloc.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/utils/date_utils.dart';
import 'package:residencias_app/widgets/loading_indicator.dart';

class SolicitudesView extends StatelessWidget {
  const SolicitudesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SolicitudesBloc, PermisosState>(
      builder: (context, state) {
        if(state is PermisosLoading) {
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
        return _crearSolicitudItem( permiso, onTap: (){
          Navigator.pushNamed(context, 'detailPage', arguments: [permiso, Acciones.preceptor, BlocProvider.of<SolicitudesBloc>(context)]);
        });
      }
    );
  }

  Widget _crearSolicitudItem(Permiso solicitud, { @required Function onTap }) {
    return ListTile(
      leading: CircleAvatar(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(solicitud.residenteNombre, overflow: TextOverflow.ellipsis,)),
          Text(
            DateUtils.fechaCreado(solicitud.createdAt),
            style: TextStyle(fontSize: 14.00),),
        ],
      ),
      subtitle: Text('${solicitud.residenteCodigo}'),
      onTap: onTap,
    );
  }

  // OnOpsCallBack _revisarPermisoFunc() {
  //   return (permisoId, nombre) { 
  //     BlocProvider.of<SolicitudesBloc>(context).add(
  //       AddOperacionPermiso(permisoId, null)
  //     );
  //   };
  // }
}