import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:residencias_app/models/others.dart';
import 'package:residencias_app/utils/date_utils.dart';

class AddPage extends StatefulWidget {
  final OnCreateCallBack onSave;
  final ResidenteObj residenteObj;    
  final _motivosList = const ['Paseo','Viaje','Compras','Personales'];
  final _parentescoList = const ['Padre','Madre','Tío','Tía','Hermano mayor', 'Otro'];

  const AddPage({@required this.onSave, @required this.residenteObj, Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _fechsalida = new TextEditingController();
  TextEditingController _fechentrada = new TextEditingController();
  String _lugar;
  String _motivo;
  String _parentescoap;
  String _comentarios;
  int _ncelular;
  DateTime _fsalida;
  DateTime _fentrada;
  // String 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.residenteObj==null ? Text('Nueva solicitud'):Text('Nuevo permiso'),
        actions: <Widget>[
          FlatButton(
            child: Text('ENVIAR', style: TextStyle(color: Colors.white,)),
            onPressed: _onSubmit,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              widget.residenteObj!=null ? _mostrarResidenteObj(widget.residenteObj) : Container(),
              _crearCampoLugar(),
              _crearCampoMotivo(),
              _crearCamposFechas(),
              _crearCampoParentesco(),
              _crearCampoCelular(),
              _crearCampoComentarios(),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(widget.residenteObj == null)
      widget.onSave(_lugar, _motivo, _fsalida, _fentrada, _parentescoap, _ncelular, _comentarios, widget.residenteObj);
      Navigator.pop(context);
    }
  }

  Widget _mostrarResidenteObj(ResidenteObj residente) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text('${residente.residenteNombre}'),
      subtitle: Text('${residente.residenteCodigo}'),
    );
  }

  Widget _crearCampoLugar() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.location_on),
        hintText: 'Lugar de destino',
      ),
      validator: (val) => val.trim().isEmpty ? 'Este campo es requerido.' : null,
      onSaved: (value) {
        _lugar = value;
      },
    );
  }

  Widget _crearCampoMotivo() {
    return DropdownButtonFormField(
      value: _motivo,
      hint: Text('Motivo'),
      decoration: InputDecoration(
        icon: Icon(Icons.help_outline),
      ),
      items: widget._motivosList.map(
        (m) => DropdownMenuItem( child: Text(m), value: m )               
      ).toList(),
      onChanged: (value) {
        setState(() { _motivo = value; });
      },
      validator: (val) => val==null ? 'Este campo es requerido.' : null,
    );
  }

  Widget _crearCamposFechas() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.date_range)
        ),
        Flexible(
          child: TextFormField(
            controller: _fechsalida,
            decoration: InputDecoration(
              hintText: 'Fecha de salida',
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _mostrarDateTimeSelector(
                (datetime) { 
                  setState(() {
                    _fsalida = datetime;
                    _fechsalida.text = DateUtils.formatDateTime(datetime);                              
                  });
                }
              );
            },
            validator: (val) => val.trim().isEmpty ? 'Este campo es requerido.' : null,
          ),
        ),
        SizedBox(width: 10.0,),
        Flexible(
          child: TextFormField(
            controller: _fechentrada,
            decoration: InputDecoration(
              hintText: 'Fecha de retorno',  
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _mostrarDateTimeSelector(
                (datetime) {
                  setState(() {
                    _fentrada = datetime;
                    _fechentrada.text = DateUtils.formatDateTime(datetime);                             
                  });
                }
              );
            },
            validator: (val) => val.trim().isEmpty ? 'Este campo es requerido.' : null,
          )
        ),
      ],
    );
  }

  Widget _crearCampoParentesco() {
    return DropdownButtonFormField(
      value: _parentescoap,
      hint: Text('Parentesco del apoderado '),
      decoration: InputDecoration(
        icon: Icon(Icons.supervisor_account),
      ),
      items: widget._parentescoList.map(
        (m) => DropdownMenuItem( child: Text(m), value: m )               
      ).toList(),
      onChanged: (value) {
        setState(() { _parentescoap = value; });
      },
      validator: (val) => val==null ? 'Este campo es requerido.' : null,
    );
  }

  Widget _crearCampoCelular() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        icon: Icon(Icons.add_call),
        hintText: 'Número de celular',
      ),
      validator: (val) {
        if(val.trim().isEmpty) return 'Este campo es requerido.';
        else if(num.tryParse(val)==null) return 'Este campo debe ser numérico.';
        else return null;
      },
      onSaved: (value) {
        _ncelular = int.parse(value);
      },
    );
  }

  Widget _crearCampoComentarios() {
    return TextFormField(                
      maxLines: 5,
      decoration: InputDecoration(
        icon: Icon(Icons.message),
        hintText: 'Comentarios',
      ),
      onSaved: (value) {
        _comentarios = value;
      },
    );
  }

  void _mostrarDateTimeSelector(Function(DateTime) onConfirm) {
    DatePicker.showDateTimePicker(context,
      minTime: DateTime(2019, 11, 1),
      maxTime: DateTime(2019, 12, 31),
      locale: LocaleType.es,
      onConfirm: onConfirm,  
    );
  }
}