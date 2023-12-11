import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class parteInfo extends StatefulWidget {
  const parteInfo({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.imagen_url,

  });

  final String? nombre;
  final String? descripcion;
  final String? imagen_url;

  @override
  State<parteInfo> createState() => _parteInfoState();
}

class _parteInfoState extends State<parteInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Información",
              style: TextStyle(color: Colors.black)),
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
                  "Información de la parte",
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
                    child: CachedNetworkImage(
                      imageUrl: widget.imagen_url ?? "Null",
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Nombre",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.nombre}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Descripción",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.descripcion}",
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