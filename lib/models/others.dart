class MicroUser {
  final String uid;
  final String displayName;
  final String rol;

  const MicroUser(this.uid, this.displayName, this.rol);
}
//Acciones de las paginas detalle
enum Acciones { preceptor, seguridad }
//Accion de la pagina NuevoPermiso
typedef OnCreateCallBack = Function(
  String lugar,
  String motivo,
  DateTime fsalida,
  DateTime fentrada,
  String parentescoap,
  int ncelular,
  String comentarios,
  ResidenteObj objetivo,
);
//
typedef OnOpsCallBack = Function(
  String permisoId, String nombre
);
//
//Modelo de residente objetivo
class ResidenteObj {
  final String residenteId;
  final String residenteNombre;
  final int residenteCodigo;

  const ResidenteObj(this.residenteId, this.residenteNombre, this.residenteCodigo);
}