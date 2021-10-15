import 'dart:math';

class TareasModel
{
  int? id_tarea;
  String? nombre;
  String? descripcion;
  String? fecha;
  int? entregada;

  TareasModel({this.id_tarea, this.nombre, this.descripcion, this.fecha, this.entregada});
  
  // Map -> Object
  factory TareasModel.fromMap(Map<String, dynamic> map)
  {
    return TareasModel(
      id_tarea: map['id_tarea'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      fecha: map['fecha'],
      entregada: map['entregada']
    );
  }

  // Object -> Map
  Map<String, dynamic> toMap()
  {
    return {
      'id_tarea': id_tarea,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha': fecha,
      'entregada': entregada
    };
  }
}