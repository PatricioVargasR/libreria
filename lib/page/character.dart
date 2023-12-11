import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class personajeInfo extends StatefulWidget {
  const personajeInfo({
    super.key,
    required this.identificador,
    required this.stand,
    required this.referencia,
    required this.fecha_nacimiento,
    required this.nacionalidad,
    required this.imagen

  });

  final String? identificador;
  final String? stand;
  final String? referencia;
  final String? fecha_nacimiento;
  final String? nacionalidad;
  final String? imagen;


  @override
  State<personajeInfo> createState() => _personajeInfoState();
}

class _personajeInfoState extends State<personajeInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Datos del personaje",
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
                  "Información del personaje",
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
                      imageUrl: widget.imagen ?? "Null",
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
                  Text("${widget.identificador}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Stand",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.stand}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Referencia",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.referencia}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Fecha de Nacimiento",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.fecha_nacimiento}",
                    style:const TextStyle(fontSize: 20),
                  ),
                  const Text("Nacionalidad",
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 7),
                  Text("${widget.nacionalidad}",
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