import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:residencias_app/models/permiso.dart';

class PermisosRepository {  
  //SINGLETON
  static final PermisosRepository _authRepository = new PermisosRepository._internal();
  factory PermisosRepository() => _authRepository;
  PermisosRepository._internal();
  //END DSINGLETON

  final permisoCollection =  Firestore.instance.collection('periodo/2019II/permisos');
  // final _createPermisoFunc =  CloudFunctions.instance.getHttpsCallable(functionName: 'createPermiso');

  Future<void> addNewPermiso(Permiso permiso) {
    return permisoCollection.add(permiso.toDocument());
    // print(permiso);
    // return _createPermisoFunc.call(
    //   permiso.toDocument()
    // ).then((res) => print(res.data));
  }  

  Future<void> deletePermiso(String permisoId) {
    return permisoCollection.document(permisoId).delete();
  }

  Future<void> pushOperacionPermiso(String permisoId, Operacion operacion) {
    return permisoCollection.document(permisoId)
      .updateData({ 'operaciones.${operacion.order}': operacion.toJson() });
  }

  Future<void> pushOperacionAprobar(String permisoId, Operacion operacion) {
    return permisoCollection.document(permisoId)
      .updateData({ 'operaciones.${operacion.order}': operacion.toJson(), 'isOK': true });
  }
  
  Future<Permiso> getPermisoById(String permisoId) {
    return permisoCollection.document(permisoId).get().then(
      (doc) => Permiso.fromSnapshot(doc)
    );
  }

  Future<List<Permiso>> getPermisosByCodigo(int codigo) {
    return permisoCollection
      .where('residenteCodigo', isEqualTo: codigo)
      .where('isOK', isEqualTo: true)
      .where('operaciones.2', isEqualTo: {})
      .getDocuments().then(
        (docs) {
          return docs.documents
            .map((doc) => Permiso.fromSnapshot(doc))
            .toList();
        }
    );
  } 

  Stream<List<Permiso>> getMisPermisos(String uid) {
    return permisoCollection.where('residenteId', isEqualTo: uid)
    .snapshots().map((snapshot) {
      return snapshot.documents
        .map((doc) => Permiso.fromSnapshot(doc))
        .toList();
    });
  }

  Stream<List<Permiso>> getTodosPermisos() {
    return permisoCollection.where('isOK',isEqualTo: true)
    .snapshots().map((snapshot) {
      return snapshot.documents
      .map((doc) => Permiso.fromSnapshot(doc))
      .toList();
    });
  } 

  Stream<List<Permiso>> getTodasSolicitudes() {
    return permisoCollection.where('isOK',isEqualTo: false)
    .snapshots().map((snapshot) {
      return snapshot.documents
      .map((doc) => Permiso.fromSnapshot(doc))
      .toList();
    });
  }
}