import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:hive/hive.dart';

class BovedaProviderOffline {
  final Box<Boveda> _box=Hive.box<Boveda>('boveda');

  Future<void> clearBoveda()async{
    final box = await Hive.openBox('boveda');
    await box.clear();
  }

  Future<Boveda> getAll(String idPeaje)async {
    return _box.values.firstWhere((b) => b.idpeaje == idPeaje);
  }

  Future<void> saveBoveda(Boveda boveda) async{
    await _box.put(boveda.id, boveda);
  }

}