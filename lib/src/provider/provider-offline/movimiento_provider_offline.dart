

import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class MovimientoProviderOffline {

  final Box<Movimiento> _box= Hive.box<Movimiento>('movimientos');
  final Box<Movimiento> _boxTransacciones= Hive.box<Movimiento>('transacciones');

  final uuid = Uuid();
  Future<void> saveMovimiento(Movimiento movimiento) async{
    await _box.put(movimiento.id, movimiento);
  }

  Future<void> saveTransaccion(Movimiento movimiento) async{
    movimiento.id = uuid.v4();
    await _boxTransacciones.put(movimiento.id, movimiento);
  }

  Future<void> saveMovimientos(List<Movimiento> movivmientos) async{
    for(var movimiento in movivmientos){
      await _box.put(movimiento.id, movimiento);
    }
  }

  Future<void> clearTransacciones()async{
    final box = await Hive.openBox<Movimiento>('transacciones');
    await box.clear();
  }


  Future<void> clearMovimientos()async{
    final box = await Hive.openBox<Movimiento>('movimientos');
    await box.clear();
  }

  List<Movimiento> getMovimientoByTurno(String idTurno) {
    return _box.values
        .where((m) => m.idturno == idTurno)
        .toList();
  }

  Movimiento getApertura(String idTurno) {
    return _box.values
        .firstWhere((m) => m.idturno == idTurno && m.idTipoMovimiento=='1');
  }


}