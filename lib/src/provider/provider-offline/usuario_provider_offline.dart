import 'package:hive/hive.dart';
import '../../models/usuario.dart';

class UsuarioProviderOffline {

  final Box<Usuario> _box = Hive.box<Usuario>('usuarios');

  Future<void> saveUsuario(Usuario usuario) async {
    await _box.put(usuario.id, usuario);
  }

  Future<void> saveUsuarios(List<Usuario> usuarios) async {
    for (var usuario in usuarios) {
      await _box.put(usuario.id, usuario);
    }
  }

  Future<void> clearUsuarios() async {
    final box = await Hive.openBox<Usuario>('usuarios');
    await box.clear();
  }

  List<Usuario> getAll() {
    return _box.values.toList();
  }

  Usuario? getUsuarioById(String idUsuario) {
    return _box.get(idUsuario);
  }

  Future<void> deleteUsuario(String idUsuario) async {
    await _box.delete(idUsuario);
  }

  List<Usuario> findByGrupo(String idGrupo, String idPeaje) {
    return _box.values
        .where((u) => u.grupo == idGrupo && u.idPeaje == idPeaje)
        .toList();
  }

  List<Usuario> findByEstadoTurno(String idEstado, String idPeaje) {
    return _box.values
        .where((u) => u.estado == idEstado && u.idPeaje == idPeaje)
        .toList();
  }

  List<Usuario> findByTurno(String idTurno) {
    return _box.values
        .where((u) => u.idTurno == idTurno)
        .toList();
  }

  List<Usuario> findByRol(String idRol) {
    return _box.values
        .where((u) => u.idRol == idRol)
        .toList();
  }

  List<String> getGrupos() {
    return _box.values
        .map((u) => u.grupo ?? '')
        .toSet()
        .toList()
      ..removeWhere((grupo) => grupo.isEmpty);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
