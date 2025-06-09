import 'package:asistencia_vial_app/src/models/estado.dart';
import 'package:hive/hive.dart';
import '../../models/usuario.dart';

class EstadoProviderOffline {

  final Box<Estado> _box = Hive.box<Estado>('estado');


  Future<void> clearEstado() async {
    final box = await Hive.openBox<Estado>('estado');
    await box.clear();
  }

  List<Estado> getAll() {
    return _box.values.toList();
  }

  Future<void> saveEstados(List<Estado> estados) async {
    for (var estado in estados) {
      await _box.put(estado.id, estado);
    }
  }

}
