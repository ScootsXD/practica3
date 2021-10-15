import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica/src/database/database_helper.dart';
import 'package:practica/src/models/tareas_model.dart';
import 'package:practica/src/utils/color_settings.dart';

class AgregarTareaScreen extends StatefulWidget
{
  TareasModel? tarea;
  AgregarTareaScreen({Key? key, this.tarea}) : super(key: key);

  @override
  _AgregarTareaScreenState createState() => _AgregarTareaScreenState();
}

class _AgregarTareaScreenState extends State<AgregarTareaScreen>
{
  DateTime selectedDate = DateTime.now();
  String? formattedDate;

  _selectDate(BuildContext context) async
  {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate)
    {
      setState(()
      {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  late DatabaseHelper _databaseHelper;

  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerDescripcion = TextEditingController();

  @override
  void initState()
  {
    if(widget.tarea != null)
    {
      _controllerNombre.text = widget.tarea!.nombre!;
      _controllerDescripcion.text = widget.tarea!.descripcion!;
      formattedDate = widget.tarea!.fecha!;
    }

    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSettings.colorPrimary,
        title: widget.tarea == null ? Text('Agregar Tarea') : Text('Editar Tarea'),
      ),
      body: ListView(
        children: [
          _crearTextFieldTitulo(),
          SizedBox(height: 10),
          _crearTextFieldDescripcion(),
          SizedBox(height: 10),
          // _crearTextFieldFecha(),
          
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: formattedDate == null ? Text('Ingresar fecha de entrega') : Text('Fecha: ' + formattedDate!)
          ),

          ElevatedButton(
            onPressed: ()
            {
              TareasModel tarea = TareasModel(
                nombre: _controllerNombre.text,
                descripcion: _controllerDescripcion.text,
                fecha: formattedDate,
                entregada: 0
              );

              _databaseHelper.insert(tarea.toMap()).then(
                (value)
                {
                  if(value > 0)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registro insertado correctamente'))
                    );

                    _databaseHelper.delete(widget.tarea!.id_tarea!);
                  }
                  else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('La solicitud no se completo'))
                    );
                  }
                }
              );
            },
            child: Text('Guardar Tarea'),
          )
        ],
      ),
    );
  }

  Widget _crearTextFieldTitulo()
  {
    return TextField(
      controller: _controllerNombre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Nombre de la tarea",
        errorText: "Este campo es obligatorio"
      ),
      onChanged: (value)
      {

      },
    );
  }

  Widget _crearTextFieldDescripcion()
  {
    return TextField(
      controller: _controllerDescripcion,
      maxLines: 8,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Descripcion de la tarea",
        errorText: "Este campo es obligatorio"
      ),
      onChanged: (value)
      {
        
      },
    );
  }

  // Widget _crearTextFieldFecha()
  // {
  //   return TextField(
  //     controller: _controllerFecha,
  //     keyboardType: TextInputType.datetime,
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10)
  //       ),
  //       labelText: "Fecha de entrega de la tarea",
  //       errorText: "Este campo es obligatorio"
  //     ),
  //     onChanged: (value)
  //     {
        
  //     },
  //   );
  // }
}