import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:hive/hive.dart';

class TipoMovimientoProviderOffline {

  final Box<Movimiento> _box=Hive.box<Movimiento>('tipoMovimiento');

  Future<void> saveTipoMovimientos(List<Movimiento> tiposMovimientos) async {
    for(var tipoMovimiento in tiposMovimientos){
      await _box.put(tipoMovimiento.idTipoMovimiento, tipoMovimiento);
    }
  }

  List<Movimiento> getAll()  {
    return _box.values.toList();
  }

  Future<void> clearAll() async{
    await _box.clear();
  }
}