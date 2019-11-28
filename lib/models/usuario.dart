
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  final String key;
  final String email;
  final String nombres;
  final String apellidos;
  final String photoURL;
  final int codigo;
  final String escuela;
  final String genero;
  final int ncelular;
  final String fechanac;
  final String tipoAut;
  final String rol;

  const Usuario(
    this.key,
    this.email,
    this.nombres,
    this.apellidos,
    this.photoURL,
    this.codigo,
    this.escuela,
    this.genero,
    this.ncelular,
    this.fechanac,
    this.tipoAut,
    this.rol
  );

  @override
  List<Object> get props => [
    key, email, nombres, apellidos, photoURL, codigo, escuela, genero, ncelular, fechanac, tipoAut, rol
  ];

  @override
  String toString() =>
    'Usuario { $key, $email, $nombres, $apellidos, $photoURL, $codigo, $escuela, $genero, $ncelular, $fechanac, $tipoAut, $rol }';

  factory Usuario.fromSnapshot(DocumentSnapshot snap) {
    return Usuario(
      snap.documentID,
      snap.data['email'],
      snap.data['nombres'],
      snap.data['apellidos'],
      snap.data['photoURL'],
      snap.data['codigo'],
      snap.data['escuela'],
      snap.data['genero'],
      snap.data['ncelular'],
      snap.data['fechanac'],
      snap.data['tipoAut'],
      snap.data['rol'],
    );
  }
}