import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:residencias_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/permisos_bloc.dart';
import 'package:residencias_app/blocs/permiso_bloc/permiso_bloc.dart';
import 'package:residencias_app/blocs/permisos_blocs/solicitudes_bloc.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/models/permiso.dart';
import 'package:residencias_app/utils/date_utils.dart';
import 'package:bloc/bloc.dart';

class DetailPage extends StatelessWidget {
  final _estado = const ['Autorización','Control de Salida','Control de Entrada','Revisión'];
  final Acciones _actions;
  final Permiso _permiso;
  final Bloc _bloc;

  DetailPage({Key key,
    @required item,
    @required Acciones actions,
    @required Bloc bloc,
  }) :
   _actions = actions,
   _bloc = bloc,
   _permiso = item,
   super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
      ),
      body: ListView(        
        children: _crearDetails(context),
      ),
      floatingActionButton: _crearActionsFab(context),
    );
  }

  List<Widget> _crearDetails(BuildContext context) {
    List<Widget> props = [];
    if(_actions==null) _agregarQr(props, context);
    else _agregarResidenteProps(props);
    props.addAll(
      <Widget>[
        ListTile(
          title: Text('Lugar'),
          subtitle: Text(_permiso.lugar),
        ),
        ListTile(
          title: Text('Motivo'),
          subtitle: Text(_permiso.motivo),
        ),
        ListTile(
          title: Text('Fecha de salida'),
          subtitle: Text(DateUtils.formatDateTime(_permiso.fsalida)),
        ),
        ListTile(
          title: Text('Fecha de entrada'),
          subtitle: Text(DateUtils.formatDateTime(_permiso.fentrada)),
        ),
        ListTile(
          title: Text('Comentarios'),
          subtitle: Text(_permiso.comentarios.isEmpty?'(Vacío)':_permiso.comentarios),
        ),    
      ]
    );
    if(_permiso.operaciones.isNotEmpty) _agregarOperaciones(props);

    return props;
  }

  void _agregarQr(List<Widget> props, BuildContext context) {
    if( _permiso.isOK && _permiso.operaciones.length<3) {//El tercero es el ultimo que requiere QR
      final ancho = MediaQuery.of(context).size.width;
      props.add(
        Center(
          child: QrImage(
            data: 'key:${_permiso.key}',
            size: ancho*0.6,
          ),
        )
      );
    }
  }

  void _agregarResidenteProps(List<Widget> props) {
    props.add(
      ListTile(
        leading: CircleAvatar(),
        title: Text(_permiso.residenteNombre),
        subtitle: Text('${_permiso.residenteCodigo}'),
        trailing: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: (){},
        ),
      )
    );
  }

  void _agregarOperaciones(List<Widget> operacion) {
    operacion.add( Text('Estado') );
    int count = 0;
    _permiso.operaciones.forEach(
      (op) {
        operacion.add(
          ListTile(
            title: Text(_estado[count++]),
            subtitle: Text(op.nombre+'\n'+DateUtils.formatDateTime(op.updatedAt)),
          )
        );
      }
    );
  }

  Widget _crearActionsFab(BuildContext context) {
    switch(_actions) {
      case Acciones.preceptor: return _crearPreceptorFab(context); break;
      case Acciones.seguridad: return _crearSeguridadFab(context); break;
      default: return null; break;
    }
  }

  Widget _crearPreceptorFab(BuildContext context) {

    if(_permiso.operaciones.isEmpty) { // Necesita aprobacion
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.check_circle),
            label: 'Aprobar',
            // onTap: (){ _onAprobCallBack( _permiso.key,null ); Navigator.pop(context); },
            onTap: () { ( _bloc as SolicitudesBloc ).add(AprobacionPermiso(_permiso.key, _getOperacion(context,0)));
                          Navigator.pop(context); },
          ),
          SpeedDialChild(
            child: Icon(Icons.cancel),
            label: 'Rechazar',
            onTap: () {
              ( _bloc as SolicitudesBloc ).add( DeletePermiso(_permiso.key) );
              Navigator.pop(context);
            },
            // onTap: () { _onDenegCallBack( _permiso.key,null ); Navigator.pop(context); }
          ),
        ],
      );
    } else
      if(_permiso.operaciones.length<4) {// Puede ser revisado
        return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Icon(Icons.remove_red_eye),
              label: 'Confirmar revisión',
              onTap: () { ( _bloc as PermisosBloc).add(AddOperacionPermiso(_permiso.key, _getOperacion(context,3)));
                          Navigator.pop(context); }
            ),
          ],
        );
      } else return null;
  }

  Widget _crearSeguridadFab(BuildContext context) {
    if(_permiso.operaciones.isEmpty || _permiso.operaciones.length>3) return null;

    if(_permiso.operaciones.length<2) { //Control de salida
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.flight_takeoff),
            label: 'Confirmar salida',
            onTap: () { ( _bloc as PermisoBloc ).add( AddOperacionControl(_permiso.key, _getOperacion(context,1)));
                        Navigator.pop(context); }
          ),
        ],
      );
    } else { //Control de entrada
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.flight_land),
            label: 'Confirmar entrada',
            // onTap: () { _onControlEntradaCallBack(_permiso.key, null); Navigator.pop(context); }
            onTap: () { ( _bloc as PermisoBloc ).add( AddOperacionControl(_permiso.key, _getOperacion(context,2)) );
                        Navigator.pop(context); }
          ),
        ],
      );
    }
  }

  Operacion _getOperacion(BuildContext context, int order) {
    final currentUser = (BlocProvider.of<AuthBloc>(context).state as Authenticated).usuario;
    return Operacion(
      '${currentUser.nombres} ${currentUser.apellidos}',
      order: order,
    );
  }
}