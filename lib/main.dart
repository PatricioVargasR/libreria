import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libreria/convert_utility.dart';
import 'package:libreria/dbManager.dart';
import 'package:libreria/book.dart';
import 'image_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Book>>? Bookss;

  TextEditingController controlNumController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController editorialController = TextEditingController();
  TextEditingController paginasController = TextEditingController();
  TextEditingController edicionController = TextEditingController();

  String? isbn = '';
  String? titulo = '';
  String? autor = '';
  String? editorial = '';
  String? paginas = '';
  String? edicion = '';
  String? photoname = '';

  //Update control
  int? currentBookId;

  //String? currentBookIsbn;

  // Variable para guardar la imagen
  var image;

  final formKey = GlobalKey<FormState>();
  late var dbHelper;

  // Variable para verificar si estamos actualizando
  late bool isUpdating;

  //Métodos de usaurio
  refreshList() {
    setState(() {
      Bookss = dbHelper.getBooks();
    });
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640)
        .then((value) async {
      Uint8List? imageBytes = await value!.readAsBytes();
      setState(() {
        photoname = Utility.base64String(imageBytes!);
      });
    });
  }

  clearFields() {
    controlNumController.text = '';
    isbnController.text = '';
    tituloController.text = '';
    editorialController.text = '';
    autorController.text = '';
    paginasController.text = '';
    edicionController.text = '';

    photoname = '';
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBManager();
    refreshList();
    isUpdating = false;
  }

  Widget userForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            const SizedBox(height: 10),
            //TextFormField(
            //controller: controlNumController,
            //keyboardType: TextInputType.number,
            //decoration: const InputDecoration(
            //labelText: 'Control Number',
            // ),
            //validator: (val) => val!.isEmpty ? 'Enter Control Number' : null,
            //onSaved: (val) => controlNumController.text = val!,
            // ),
            TextFormField(
              controller: tituloController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Titulo del Libro',
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[A-Za-z ]+$')
                        .hasMatch(value)) {
                  return "Ingresa un valor valido";
                }
                return null;
              },
              onSaved: (value) => titulo = value,
            ),
            TextFormField(
              controller: autorController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Autor/Autores',
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[A-Za-z ]+$")
                        .hasMatch(value)) {
                  return "Ingresa un valor valido";
                }
                return null;
              },
              onSaved: (value) => autor = value,
            ),
            TextFormField(
              controller: editorialController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Editorial',
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[A-Za-z ]+$")
                        .hasMatch(value)) {
                  return "Ingresa un valor valido";
                }
                return null;
              },
              onSaved: (value) => editorial = value,
            ),
            TextFormField(
              controller: paginasController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'No. Páginas',
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Ingresa solo números";
                }
                return null;
              },
              onSaved: (val) => paginas = val!,
            ),
            TextFormField(
              controller: edicionController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Edición',
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Ingresa un valor válido";
                }
                return null;
              },
              onSaved: (val) => edicion = val!,
            ),
            TextFormField(
              controller: isbnController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'ISBN',
              ),
              validator: (value) {
                if (value!.isEmpty || value.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Ingresa un ISBN correcto";
                }
                return null;
              },
              onSaved: (val) => isbn = val!,
            ),
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
                MaterialButton(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.green)),
                  child: const Text("Seleccionar imagen"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView userDataTable(List<Book>? Bookss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Foto')),
          DataColumn(label: Text('Titulo')),
          DataColumn(label: Text('Autor/Autores')),
          DataColumn(label: Text('Editorial')),
          DataColumn(label: Text('No. Páginas')),
          DataColumn(label: Text('Edición')),
          DataColumn(label: Text('ISBN')),
          DataColumn(label: Text('Eliminar')),
        ],
        rows: Bookss!
            .map((book) => DataRow(cells: [
                  DataCell(
                      Container(
                        width: 80,
                        height: 120,
                        child: Utility.ImageFromBase64String(book.photoName!),
                      ), onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => imageInfo(
                              photo: book.photoName,
                              titulo: book.titulo,
                              autor: book.autor,
                              editorial: book.editorial,
                              paginas: book.paginas,
                              edicion: book.edicion,
                              isbn: book.isbn)),
                    );
                  }),
                  DataCell(Text(book.titulo!), onTap: () {
                    setState(() {
                      // En caso de que se actualice
                      isUpdating = true;
                      // Obtiene el ID y la Imagen del registro seleccionado
                      currentBookId = book.controlNum;
                      image = book.photoName;
                    });
                    tituloController.text = book.titulo!;
                    autorController.text = book.autor!;
                    editorialController.text = book.editorial!;
                    paginasController.text = book.paginas!;
                    edicionController.text = book.edicion!;
                    isbnController.text = book.isbn!;
                  }),
                  DataCell(Text(book.autor!)),
                  DataCell(Text(book.editorial!)),
                  DataCell(Text(book.paginas!)),
                  DataCell(Text(book.edicion!)),
                  DataCell(Text(book.isbn!)),
                  DataCell(IconButton(
                    onPressed: () {
                      dbHelper.delete(book.controlNum);
                      refreshList();
                    },
                    icon: const Icon(Icons.delete),
                  ))
                ]))
            .toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Bookss,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return userDataTable(snapshot.data);
                }
                if (!snapshot.hasData) {
                  print("Data Not Found");
                }
                return const CircularProgressIndicator();
              }),
        ));
  }

  validate() {
    // Validar los métodos
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        // Verifica imagen
        if (photoname == null || photoname!.isEmpty) {
          // Conservar la imagen existente si photoname está vacío
          photoname = image;
        }
        // Asigna los valores que se vayan a actualizar
        Book book = Book(
          controlNum: currentBookId,
          titulo: titulo,
          autor: autor,
          editorial: editorial,
          paginas: paginas,
          edicion: edicion,
          isbn: isbn,
          photoName: photoname,
        );
        // Actualiza con el método correspondiente
        dbHelper.update(book);

        isUpdating = false;
        // Limpia las entradas de datos y refresca la tabla
        clearFields();
        refreshList();
      } else {
        // Verifica imagne
        if (photoname == null || photoname!.isEmpty) {
          // Muestra una alerta si no se ha seleccionado una imagen al crear un nuevo registro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selecciona una imagen.'),
            ),
          );
        } else {
          // Asigna los valores correspondientes
          Book book = Book(
            controlNum: null,
            titulo: titulo,
            autor: autor,
            editorial: editorial,
            paginas: paginas,
            edicion: edicion,
            isbn: isbn,
            photoName: photoname,
          );
          // Guarda el nuevo registro con el método correspondiente
          dbHelper.save(book);
          // Limpia las entradas y vuelve a cargas la tabla
          clearFields();
          refreshList();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Evitar botón de regreso
        automaticallyImplyLeading: false,
        title: const Text('Libros',
            style: TextStyle(color: Colors.white60)),
        backgroundColor: Colors.brown,
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearch(dbHelper));
              })
        ],
      ),
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        //verticalDirection: VerticalDirection.down,
        children: [userForm(), list()],
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  final DBManager dbHelper;

  CustomSearch(this.dbHelper);


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Realiza la búsqueda en la base de datos y obtén los libros
    Future<List<Book>> searchBooks() async {
      // Realiza una consulta a la base de datos para obtener los libros
      return await dbHelper.searchBooksByTitle(query);
    }

    return FutureBuilder<List<Book>>(
      future: searchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No se encontraron resultados');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var book = snapshot.data![index];
              return ListTile(
                title: Text(book.titulo!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => imageInfo(
                        autor: book.autor ?? 'Sin información',
                        titulo: book.titulo ?? 'Sin información',
                        edicion: book.edicion ?? 'Sin información',
                        editorial: book.editorial ?? 'Sin información',
                        isbn: book.isbn ?? 'Sin información',
                        paginas: book.paginas ?? 'Sin información',
                        photo: book.photoName ?? 'Sin información',),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Realiza la búsqueda en la base de datos y obtén los libros
    Future<List<Book>> searchBooks() async {
      // Realiza una consulta a la base de datos para obtener los libros
      return await dbHelper.searchBooksByTitle(query);
    }

    return FutureBuilder<List<Book>>(
      future: searchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No se encontraron resultados');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var book = snapshot.data![index];
              return ListTile(
                title: Text(book.titulo!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => imageInfo(
                          autor: book.autor ?? 'Sin información',
                      titulo: book.titulo ?? 'Sin información',
                      edicion: book.edicion ?? 'Sin información',
                      editorial: book.editorial ?? 'Sin información',
                      isbn: book.isbn ?? 'Sin información',
                      paginas: book.paginas ?? 'Sin información',
                      photo: book.photoName ?? 'Sin información',),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

}
