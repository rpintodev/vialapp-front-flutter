import 'package:hive/hive.dart';
import 'package:asistencia_vial_app/src/models/usuario.dart';
import 'package:asistencia_vial_app/src/models/rol.dart';
import 'package:asistencia_vial_app/src/models/movimiento.dart';
import 'package:asistencia_vial_app/src/models/boveda.dart';
import 'package:asistencia_vial_app/src/models/estado.dart';
import 'package:asistencia_vial_app/src/models/peaje.dart';
import 'package:asistencia_vial_app/src/models/turno.dart';

void registerAdapters() {
	Hive.registerAdapter(UsuarioAdapter());
	Hive.registerAdapter(RolAdapter());
	Hive.registerAdapter(MovimientoAdapter());
	Hive.registerAdapter(BovedaAdapter());
	Hive.registerAdapter(EstadoAdapter());
	Hive.registerAdapter(PeajeAdapter());
	Hive.registerAdapter(TurnoAdapter());
}
