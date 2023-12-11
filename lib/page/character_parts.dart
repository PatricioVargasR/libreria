import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:libreria/models/characters.dart';
import 'package:libreria/page/character.dart';
import 'package:libreria/utilities/const_app.dart';

import '../services/charactersServices.dart';
import '../widgets/container_border.dart';

class PersonajeParte extends StatefulWidget {
  const PersonajeParte({Key? key, required this.indentificador});

  final String? indentificador;

  @override
  State<PersonajeParte> createState() => _PersonajeParteState();
}

class _PersonajeParteState extends State<PersonajeParte> {
  var PersonajeHttpService = personajeHttpService();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.indentificador ?? "Personajes", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffF5F8FC),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Buscar personajes...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(
                        width: 0,
                        height: 10,
                      ),
                      FutureBuilder<List<PersonajesModel>>(
                        future: PersonajeHttpService.obtenerPersonajes(widget.indentificador),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(mensajeErrorPersonajeApi),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            List<PersonajesModel> personajes = snapshot.data!;
                            personajes = filtrarPersonajes(query, personajes);

                            if (personajes.isEmpty) {
                              return Center(
                                child: Text('No se encontraron resultados.'),
                              );
                            }

                            return ListaPersonajes(
                              personaje: personajes,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PersonajesModel> filtrarPersonajes(String query, List<PersonajesModel> personajes) {
    return personajes.where((personaje) {
      return personaje.nombre_pesonaje!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class ListaPersonajes extends StatelessWidget {
  final List<PersonajesModel> personaje;

  const ListaPersonajes({
    Key? key,
    required this.personaje,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 56,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personajes de esta parte",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
          width: 0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: personaje.length,
          itemBuilder: (context, item) {
            return ContenedorPersonaje(
              personaje: personaje[item],
            );
          },
        )
      ],
    );
  }
}

class ContenedorPersonaje extends StatelessWidget {
  final PersonajesModel personaje;

  ContenedorPersonaje({
    Key? key,
    required this.personaje,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerBorder(
      height: 120,
      width: double.infinity,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => personajeInfo(
                      identificador: personaje.nombre_pesonaje,
                      stand: personaje.stand,
                      referencia: personaje.referencia,
                      fecha_nacimiento: personaje.fecha_nacimiento,
                      nacionalidad: personaje.nacionalidad,
                      imagen: personaje.imagen,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: personaje.imagen ?? "Null",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personaje.nombre_pesonaje ?? "Parte Génerica",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  personaje.stand ?? "Stand",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
