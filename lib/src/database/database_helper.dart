import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:practica/src/models/tareas_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper
{
  static final _nombreBD = "Tareas";
  static final _versionBD = 1;
  static final _nombreTBL = "tareas";

  static Database? _database;

  Future<Database?> get database async
  {
    if(_database != null)
    {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async
  {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path, _nombreBD);

    return openDatabase(
      rutaBD,
      version: _versionBD,
      onCreate: _crearTabla
    );
  }

  Future<void> _crearTabla(Database db, int version) async
  {
    await db.execute("create table $_nombreTBL (id_tarea integer primary key, nombre varchar(50), descripcion varchar(100), fecha date, entregada boolean)");
  }

  Future<int> insert(Map<String, dynamic> row) async
  {
    print("AAAAAA");
    var conexion = await database;

    return conexion!.insert(_nombreTBL, row);
  }

  Future<void> update(int tarea) async
  {
    var conexion = await database;
    return conexion!.execute('update $_nombreTBL set entregada = 1 where id_tarea = $tarea');
  }

  Future<int> updateEntregada(Map<String, dynamic> row) async
  {
    var conexion = await database;
    return conexion!.update(_nombreTBL, row, where: 'id_tarea = $row["id_tarea"]');
  }

  Future<int> delete(int id_tarea) async
  {
    var conexion = await database;
    return await conexion!.delete(_nombreTBL, where: 'id_tarea = ?', whereArgs: [id_tarea]);
  }

  Future<List<TareasModel>> getTareas() async
  {
    var conexion = await database;
    var resultado = await conexion!.query(_nombreTBL);

    return resultado.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<List<TareasModel>> getTareasSinEntregar() async
  {
    var conexion = await database;
    var resultado = await conexion!.query("tareas where entregada = 0");

    return resultado.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<List<TareasModel>> getTareasEntregadas() async
  {
    var conexion = await database;
    var resultado = await conexion!.query("tareas where entregada = 1");

    return resultado.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<TareasModel> getNote(int id) async
  {
    var conexion = await database;
    var resultado = await conexion!.query(_nombreTBL, where: 'id_tarea = ?', whereArgs: [id]);

    return TareasModel.fromMap(resultado.first);
  }
}