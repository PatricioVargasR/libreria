import 'package:flutter/material.dart';
import 'package:libreria/convert_utility.dart';

class imageInfo extends StatefulWidget {
  const imageInfo({
    super.key,
    required this.photo,
    required this.titulo,
    required this.autor,
    required this.editorial,
    required this.paginas,
    required this.edicion,
    required this.isbn,
  });

  final String? photo;
  final String? titulo;
  final String? autor;
  final String? editorial;
  final String? paginas;
  final String? edicion;
  final String? isbn;

  @override
  State<imageInfo> createState() => _imageInfoState();
}

class _imageInfoState extends State<imageInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Datos del libro",
              style: TextStyle(color: Colors.white60)),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
                child: Text(
                  "Información del libro",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 170,
                    height: 200,
                    child: Utility.ImageFromBase64String(widget.photo!),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Titulo",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.titulo}",
                  style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Autor/Autores",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.autor}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Editorial",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.editorial}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Páginas",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.paginas}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Edición",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.edicion}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("ISBN",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.isbn}",
                    style:const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Regresar"),
            ),
          ],
        ));
  }
}
