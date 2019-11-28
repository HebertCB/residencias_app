import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residencias_app/blocs/permiso_bloc/permiso_bloc.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/widgets/loading_indicator.dart';

class ButtonView extends StatelessWidget {
  bool _isShowingLoading;

  ButtonView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermisoBloc, PermisoState>(
      listener: (context, state) {
        if(state is PermisoCargando) {
          _showModalLoading(context);
        } else if( state is CodigoInvalido) {
          _showAlertDialog(context, 'El codigo es inválido');
        } else if( state is PermisoEncontrado) {
          if(_isShowingLoading) Navigator.pop(context);
          Navigator.pushNamed(context, 'detailPage', arguments: [state.permiso, Acciones.seguridad, BlocProvider.of<PermisoBloc>(context)]);
        } else if(state is PermisoNoEncontrado) {
          _showAlertDialog(context, 'El permiso no existe.');
        } else if(state is PermisoNoAprobado) {
          _showAlertDialog(context, 'El permiso no está autorizado.');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text('Valida la información de un permiso escaneado su código QR', textAlign: TextAlign.center,),
          ),
          SizedBox( height: 10.0, width: double.infinity,),
          FloatingActionButton.extended(
            icon: Icon(Icons.filter_center_focus),
            label: Text('Escanear QR'),
            onPressed: () { _scanearCodigoQR(context); },
          )
        ],
      ),
    );
  }

  void _scanearCodigoQR(BuildContext context) async {
    String qrResult;
    try{
      qrResult = await new QRCodeReader().scan();
    } catch(e) {
      print(e);
      qrResult = null;
    }

    print(qrResult);

    if(qrResult!=null)
      BlocProvider.of<PermisoBloc>(context).add(FindPermiso(qrResult));
  }

  void _showModalLoading(BuildContext context) async {
    _isShowingLoading=true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return LoadingIndicator();
      },
    );
    _isShowingLoading=false;    
  }

  void _showAlertDialog(BuildContext context, String text) async{
    if(_isShowingLoading) Navigator.pop(context);
    
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(text,
            style: TextStyle(color: Colors.red),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}