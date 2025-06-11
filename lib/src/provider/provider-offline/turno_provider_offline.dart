import 'package:asistencia_vial_app/src/models/estado.dart';
import 'package:asistencia_vial_app/src/models/turno.dart';
import 'package:hive/hive.dart';

class TurnoProviderOffline {

  final Box<Turno> _box = Hive.box<Turno>('turno');


  Future<void> clearTurno() async {
    final box = await Hive.openBox<Estado>('turno');
    await box.clear();
  }

  List<Turno> getAll() {
    return _box.values.toList();
  }

  Future<void> saveTurno(Turno turno) async {
      await _box.put(turno.id,turno);
  }



}
