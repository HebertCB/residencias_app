import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residencias_app/models/usuario.dart';

class UsuariosRepository {
   //SINGLETON
  static final UsuariosRepository _authRepository = new UsuariosRepository._internal();
  factory UsuariosRepository() => _authRepository;
  UsuariosRepository._internal();
  //END DSINGLETON

  final usuarioCollection = Firestore.instance.collection('usuarios');

  Future<Usuario> getUser(String uid) {
    return usuarioCollection.document(uid).get().then(
      (doc) => Usuario.fromSnapshot(doc)
    );
  }

  Future<List<Usuario>> searchResidentesByNombre(String nombre) {
    return usuarioCollection
      .where('searchKeys', arrayContains: nombre)
      .getDocuments().then(
        (docs) {
          return docs.documents
            .map((doc) => Usuario.fromSnapshot(doc))
            .toList();
        }
      );
  }

  Future<List<Usuario>> searchResidenteByCodigo(String codigo) {
    final parsedCodigo = int.parse(codigo);

    return usuarioCollection
      .where('codigo', isEqualTo: parsedCodigo)
      .limit(1)
      .getDocuments().then(
        (docs) {
          return docs.documents
            .map((doc) => Usuario.fromSnapshot(doc))
            .toList();
        }
      );
  }
}