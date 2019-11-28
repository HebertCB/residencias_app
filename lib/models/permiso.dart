import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Operacion extends Equatable {
  final int order;
  final String nombre;
  final DateTime updatedAt;

  const Operacion(this.nombre, {this.order, this.updatedAt});

  @override
  List<Object> get props => [nombre, updatedAt];  

  factory Operacion.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    return Operacion(
      json['nombre'],
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, Object> toJson() {
    return {
      "nombre": nombre,
      "updatedAt": Timestamp.now(),
    };
  }
}

class Permiso extends Equatable {
  final String key;
  final String residenteId;
  final String residenteNombre;
  final int residenteCodigo;
  final String lugar;
  final String motivo;
  final DateTime fsalida;  
  final DateTime fentrada;
  final String comentarios;
  final int ncelular;
  final String parentescoAp;
  final List<Operacion> operaciones;  
  // final List<Operacion> operaciones;  
  final bool isOK;
  final DateTime createdAt;

  const Permiso(
    this.residenteId,    
    this.residenteNombre,
    this.residenteCodigo,
    this.lugar,
    this.motivo,
    this.fsalida,
    this.fentrada,
    this.parentescoAp,
    this.ncelular,
    this.comentarios,
    {
    this.createdAt,
    this.operaciones,
    this.isOK = false,
    this.key
    }
  );

  @override
  List<Object> get props => [
    key, residenteId, residenteNombre, residenteCodigo, lugar, motivo, fsalida, fentrada, comentarios, ncelular, parentescoAp, operaciones, isOK, createdAt,
  ];

  @override
  String toString() =>
    'Permiso { $key, $residenteId, $residenteNombre, $residenteCodigo, $lugar, $motivo, ${fsalida.toString()}, ${fentrada.toString()}, $comentarios, $ncelular, $parentescoAp, $operaciones, $isOK, ${createdAt.toString()}, }';

  factory Permiso.fromSnapshot(DocumentSnapshot snap) {
    List<Operacion> ops = [];
    (snap.data['operaciones'] as Map).values.forEach(
      (op) { if((op as Map).isNotEmpty) ops.add(Operacion.fromJson(op));}
    );

    return Permiso(
      snap.data['residenteId'],
      snap.data['residenteNombre'],
      snap.data['residenteCodigo'],
      snap.data['lugar'],
      snap.data['motivo'],
      (snap.data['fsalida'] as Timestamp).toDate(),
      (snap.data['fentrada'] as Timestamp).toDate(),
      snap.data['parentescoAp'],
      snap.data['ncelular'],
      snap.data['comentarios'],
      createdAt: (snap.data['createdAt'] as Timestamp).toDate(),
      operaciones: ops,
      isOK: snap.data['isOK'],
      key: snap.documentID,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "residenteId": residenteId,
      "residenteNombre": residenteNombre,
      "residenteCodigo": residenteCodigo,
      "lugar": lugar,
      "motivo": motivo,
      "fsalida": Timestamp.fromDate(fsalida),
      "fentrada": Timestamp.fromDate(fentrada),
      "comentarios": comentarios,
      "ncelular": ncelular,
      "parentescoAp": parentescoAp,
      "operaciones": operaciones==null ? {} : { '0': operaciones.first.toJson(), '1':{}, '2':{}, '3':{}} ,
      "isOK": isOK,
      "createdAt": Timestamp.now(),
    };
  }
}

