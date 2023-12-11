

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:libreria/models/characters.dart';
import 'package:libreria/models/parts.dart';
import 'package:libreria/services/characterService.dart';


void main() {
  runApp(const MyApp());
}

// Stateless
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: crudOperationsPersonajes(),
    );
  }
}

//Stful
class crudOperationsPersonajes extends StatefulWidget {
  const crudOperationsPersonajes({super.key});

  @override
  State<crudOperationsPersonajes> createState() => _crudOperationsPersonajesState();
}

class _crudOperationsPersonajesState extends State<crudOperationsPersonajes> {

  Future<List<PersonajesModel>>? Personajes;

  TextEditingController categoriaController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController standController = TextEditingController();
  TextEditingController referenciaController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController nacionalidadControler = TextEditingController();
  TextEditingController imagenController = TextEditingController();

  double valorNumerico = 0.0;

  int? categoria;
  String? nombre;
  String? stand;
  String? referencia;
  String? fecha;
  String? nacionalidad;
  String? imagen;

  final formKey = GlobalKey<FormState>();

  String? currentNombre;

  var personajeHttpService = todoPersonajeHttpService();
  late bool isUpdating;



  //Métodos de usuario



  clearFields() {
    categoriaController.text = '';
    nombreController.text = '';
    standController.text = '';
    referenciaController.text = '';
    fechaController.text = '';
    nacionalidadControler.text = '';
    imagenController.text = '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Personajes = personajeHttpService.obtenerTodosPersonaje();
    isUpdating = false;
  }

  Widget userForm() {
    return Form(
      // Formulario no debe ser constante
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: categoriaController,
              keyboardType: TextInputType.number,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Parte Original',
              ),
              validator: (val) => val!.isEmpty ? 'Ingresa la parte' : null,
              onSaved: (val) => categoria = int.parse(val!),
            ),

            TextFormField(
              controller: nombreController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Nombre del Personaje',
              ),
              validator: (val) => val!.isEmpty ? 'Ingresa un nombre' : null,
              onSaved: (val) => nombre = val!,
            ),
            TextFormField(
              controller: standController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Stand / Habilidad del personaje',
              ),
              validator: (val) =>
              val!.isEmpty ? 'Ingresa un Stand / Habilidad' : null,
              onSaved: (val) => stand = val!,
            ),
            TextFormField(
              controller: referenciaController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Referencia',
              ),
              validator: (val) =>
              val!.isEmpty ? 'Ingresa una referencia' : null,
              onSaved: (val) => referencia = val!,
            ),
            TextFormField(
              controller: fechaController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Fecha de nacimiento: YY-MM-DD',
              ),
              validator: (val) =>
              val!.isEmpty ? 'Ingresa una fecha de nacimiento' : null,
              onSaved: (val) => fecha = val!,
            ),
            TextFormField(
              controller: nacionalidadControler,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Nacionalidad',
              ),
              validator: (val) =>
              val!.isEmpty ? 'Ingresa una nacionalidad' : null,
              onSaved: (val) => nacionalidad = val!,
            ),
            TextFormField(
              controller: imagenController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'URL de la Imagen',
              ),
              validator: (val) =>
              val!.isEmpty ? 'Ingresa una URL de Imagen' : null,
              onSaved: (val) => imagen = val!,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: validate,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.red)),
                  child: Text(isUpdating ? "Actualizar" : "Insertar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Lógica de actualización aquí (puedes recargar tus datos, etc.)
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      Personajes = personajeHttpService.obtenerTodosPersonaje();
                    });
                  },
                  child: Text('Refrescar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Lista que se puede scrollear
  SingleChildScrollView userDataTable(List<PersonajesModel>? Personajess) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Foto')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Stand/Habilidad')),
            DataColumn(label: Text('Referencia')),
            DataColumn(label: Text('Fecha de Nacimiento')),
            DataColumn(label: Text('Nacionalidad')),
            DataColumn(label: Text('Eliminar')),
          ],
          rows: Personajess!
              .map((personaje) => DataRow(cells: [
            DataCell(Container(
              width: 80,
              height: 120,
              child: CachedNetworkImage(
                imageUrl: personaje.imagen ?? "Null",
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )),
            DataCell(Text(personaje.nombre_pesonaje!), onTap: () {
              setState(() {
                isUpdating = true;
                currentNombre = personaje.nombre_pesonaje;
              });
              categoriaController.text = personaje.id_parte!.toString();
              nombreController.text = personaje.nombre_pesonaje!;
              standController.text = personaje.stand!;
              referenciaController.text = personaje.referencia!;
              fechaController.text = personaje.fecha_nacimiento!;
              nacionalidadControler.text = personaje.nacionalidad!;
              imagenController.text = personaje.imagen!;
            }),

            DataCell((Text(personaje.stand!))),
            DataCell((Text(personaje.referencia!))),
            DataCell((Text(personaje.fecha_nacimiento!))),
            DataCell((Text(personaje.nacionalidad!))),
            DataCell(IconButton(
              onPressed: () {
                personajeHttpService.borrarPersonaje(personaje.nombre_pesonaje!);
              },
              icon: const Icon(Icons.delete),
            ))
          ]))
              .toList(),
        ));
  }

  Widget list() {
    // Método para expandir
    return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Personajes,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              // Verificamos datos
              if (snapshot.hasData) {
                print(snapshot.data);
                return userDataTable(snapshot.data);
              }
              if (!snapshot.hasData) {
                print("Información no encontrada");
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        PersonajesModel personajes = PersonajesModel(
            id_parte: categoria,
            nombre_pesonaje: nombre,
            stand: stand,
            referencia: referencia,
            fecha_nacimiento: fecha,
            nacionalidad: nacionalidad,
            imagen: imagen);
        personajeHttpService.actualizarDatosPersonaje(currentNombre, personajes.toJson());
        print(personajes.toJson());

      } else {
        PersonajesModel personajes = PersonajesModel(
            id_parte: categoria,
            nombre_pesonaje: nombre,
            stand: stand,
            referencia: referencia,
            fecha_nacimiento: fecha,
            nacionalidad: nacionalidad,
            imagen: imagen);
        personajeHttpService.enviarDatosPersonaje(personajes.toJson());
        print(personajes.toJson());
      }
      clearFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operaciones CRUD'),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // Lógica de actualización aquí (puedes recargar tus datos, etc.)
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            Personajes = personajeHttpService.obtenerTodosPersonaje();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            userForm(),
            list(),

          ],
        ),
      ),

    );
  }
}