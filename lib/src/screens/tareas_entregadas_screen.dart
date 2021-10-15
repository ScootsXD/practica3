// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:practica/src/database/database_helper.dart';
import 'package:practica/src/models/tareas_model.dart';
import 'package:practica/src/screens/agregar_tarea_screen.dart';
import 'package:practica/src/utils/color_settings.dart';

class TareasEntregadasScreen extends StatefulWidget
{
  const TareasEntregadasScreen({Key? key}) : super(key: key);

  @override
  _TareasEntregadasScreenState createState() => _TareasEntregadasScreenState();
}

class _TareasEntregadasScreenState extends State<TareasEntregadasScreen>
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
        title: Text('Tareas entregadas'),
      ),
      body: FutureBuilder(
        future: _databaseHelper.getTareasEntregadas(),
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
              return _listadoTareasEntregadas(snapshot.data!);
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

  Widget _listadoTareasEntregadas(List<TareasModel> tareas)
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