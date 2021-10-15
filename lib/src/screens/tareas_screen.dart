// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica/src/database/database_helper.dart';
import 'package:practica/src/models/tareas_model.dart';
import 'package:practica/src/screens/agregar_tarea_screen.dart';
import 'package:practica/src/utils/color_settings.dart';

class TareasScreen extends StatefulWidget
{
  const TareasScreen({Key? key}) : super(key: key);

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen>
{
  late DatabaseHelper _databaseHelper;

  @override
  void initState()
  {
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSettings.colorPrimary,
        title: Text('Tareas por hacer'),
        actions: [
          IconButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, '/entregadas');
            },
            icon: Icon(Icons.checklist_rounded)
          ),
          IconButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, '/agregar');
            },
            icon: Icon(Icons.add_rounded)
          )
        ],
      ),
      body: FutureBuilder(
        future: _databaseHelper.getTareasSinEntregar(),
        builder: (BuildContext context, AsyncSnapshot<List<TareasModel>> snapshot)
        {
          if(snapshot.hasError)
          {
            return Center(child: Text('Ocurrio un error en la peticion'),);
          }
          else
          {
            if(snapshot.connectionState == ConnectionState.done)
            {
              return _listadoTareas(snapshot.data!);
            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      ),
    );
  }

  Widget _listadoTareas(List<TareasModel> tareas)
  {
    return ListView.builder(
      itemBuilder: (BuildContext context, index)
      {
        TareasModel tarea = tareas[index];
        return Card(
          child: Column(
            children: [
              Text(tarea.nombre!, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 3),
              Text(tarea.descripcion!),
              SizedBox(height: 10),
              Text("Para entregar hasta el " + tarea.fecha!),
              DateTime.now().difference(DateFormat("dd-MM-yyyy").parse(tarea.fecha)).inDays > 0 ? Text("TAREA VENCIDA") : Text(""),
              tarea.entregada == 0 ? Text("Sin entregar") : Text("Entregada"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: ()
                    {
                      showDialog(
                        context: context,
                        builder: (context)
                        {
                          return AlertDialog(
                            title: Text('Confirmacion'),
                            content: Text('Poner tarea como entregada?'),
                            actions: [
                              TextButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                  _databaseHelper.update(tarea.id_tarea!).then(
                                    (noRows)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('La tarea se ha entregado'))
                                      );
                                      setState(()
                                      {

                                      });
                                    }
                                  );
                                },
                                child: Text('Si')
                              ),
                              TextButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                },
                                child: Text('No')
                              ),
                            ]
                          );
                        }
                      );
                    },
                    icon: Icon(Icons.check),
                    iconSize: 18,
                  ),
                  IconButton(
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgregarTareaScreen(tarea: tarea)
                        )
                      ); 
                    },
                    icon: Icon(Icons.edit),
                    iconSize: 18,
                  ),
                  IconButton(
                    onPressed: ()
                    {
                      showDialog(
                        context: context,
                        builder: (context)
                        {
                          return AlertDialog(
                            title: Text('Confirmacion'),
                            content: Text('Estas seguro del borrado?'),
                            actions: [
                              TextButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                  _databaseHelper.delete(tarea.id_tarea!).then(
                                    (noRows)
                                    {
                                      if(noRows > 0)
                                      {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('El registro se ha eliminado'))
                                        );
                                        setState(()
                                        {

                                        });
                                      }
                                    }
                                  );
                                },
                                child: Text('Si')
                              ),
                              TextButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                },
                                child: Text('No')
                              ),
                            ]
                          );
                        }
                      );
                    },
                    icon: Icon(Icons.delete),
                    iconSize: 18,
                  ),
                ],
              )
            ],
          ),
        );
      },
      itemCount: tareas.length,
    );
  }
}