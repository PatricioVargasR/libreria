

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:libreria/models/parts.dart';

import '../services/partsServices.dart';

void main() {
  runApp(const MyApp());
}

// Stateless
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: crudOperations(),
    );
  }
}

//Stful
class crudOperations extends StatefulWidget {
  const crudOperations({super.key});

  @override
  State<crudOperations> createState() => _crudOperationsState();
}

class _crudOperationsState extends State<crudOperations> {

  Future<List<PartesModel>>? Partes;

  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcioController = TextEditingController();
  TextEditingController imagenurlController = TextEditingController();

  String? nombre = '';
  String? descripcion = '';
  String? imagen = '';

  final formKey = GlobalKey<FormState>();

  String? currentNombre;

  var parteHttpService = ParteHttpService();
  late bool isUpdating;



  //Métodos de usuario



  clearFields() {
    nombreController.text = '';
    descripcioController.text = '';
    imagenurlController.text = '';

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Partes = parteHttpService.obtenerPartes();
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
              controller: nombreController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Nombre de la Parte',
              ),
              validator: (val) => val!.isEmpty ? 'Ingresa el nombre' : null,
              onSaved: (val) => nombre = val!,
            ),

            TextFormField(
              controller: descripcioController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
              validator: (val) => val!.isEmpty ? 'Ingresa una descripción' : null,
              onSaved: (val) => descripcion = val!,
            ),

            TextFormField(
              controller: imagenurlController,
              keyboardType: TextInputType.text,
              // Teclado númerico
              decoration: const InputDecoration(
                labelText: 'URL de la Imagen',
              ),
              validator: (val) =>
              val!.isEmpty ? 'Ingresa una URL' : null,
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
                      Partes = parteHttpService.obtenerPartes();
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
  SingleChildScrollView userDataTable(List<PartesModel>? Partess) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Foto')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Descripción')),
            DataColumn(label: Text('Eliminar')),
          ],
          rows: Partess!
              .map((parte) => DataRow(cells: [
            DataCell(Container(
              width: 80,
              height: 120,
              child: CachedNetworkImage(
                imageUrl: parte.imagen ?? "Null",
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )),
            DataCell(Text(parte.nombre_parte!), onTap: () {
              setState(() {
                isUpdating = true;
                currentNombre = parte.nombre_parte;
              });
              nombreController.text = parte.nombre_parte!;
              descripcioController.text = parte.descripcion!;
              imagenurlController.text = parte.imagen!;
            }),
            DataCell((Text(parte.descripcion!))),
            DataCell(IconButton(
              onPressed: () {
                parteHttpService.borrarParte(parte.nombre_parte!);
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
            future: Partes,
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

        PartesModel partes = PartesModel(
            nombre_parte: nombre,
            descripcion: descripcion,
            imagen: imagen);
        parteHttpService.actualizarDatosParte(currentNombre, partes.toJson());
        print(partes.toJson());

      } else {
        PartesModel partes = PartesModel(
          nombre_parte: nombre,
          descripcion: descripcion,
          imagen: imagen
        );
        parteHttpService.enviarDatosParte(partes.toJson());
        print(partes.toJson());
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
            Partes = parteHttpService.obtenerPartes();
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