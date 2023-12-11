import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libreria/models/parts.dart';
import 'package:libreria/page/character_parts.dart';
import 'package:libreria/page/crud_operations_character.dart';
import 'package:libreria/page/decision_page.dart';
import 'package:libreria/page/part.dart';
import 'package:libreria/utilities/const_app.dart';

import '../services/partsServices.dart';
import '../widgets/container_border.dart';
import 'all_characters.dart';
import 'crud_operations.dart';

class PaginaPartes extends StatefulWidget {
  const PaginaPartes({Key? key}) : super(key: key);

  @override
  State<PaginaPartes> createState() => _PaginaPartesState();
}

class _PaginaPartesState extends State<PaginaPartes> {
  var parteHttpService = ParteHttpService();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          hintText: 'Buscar partes...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(
                        width: 0,
                        height: 10,
                      ),
                      FutureBuilder<List<PartesModel>>(
                        future: parteHttpService.obtenerPartes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(mensajeErrorParteApi),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<PartesModel> partes = snapshot.data!;
                            partes = filtrarPartes(query, partes);

                            if (partes.isEmpty) {
                              return Center(
                                child: Text('No se encontraron resultados.'),
                              );
                            }

                            return ListaPartes(
                              parte: partes,
                            );
                          } else {
                            return CircularProgressIndicator();
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

  List<PartesModel> filtrarPartes(String query, List<PartesModel> partes) {
    return partes.where((parte) {
      return parte.nombre_parte!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class ListaPartes extends StatelessWidget {
  final List<PartesModel> parte;

  const ListaPartes({
    Key? key,
    required this.parte,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Coloca aquí la lógica para la redirección del ícono
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonajesParte(),
                    ),
                  );
                },
                child: const Text(
                  "Todos los personajes",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Coloca aquí la lógica para la redirección del ícono
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DecisionPage(),
                    ),
                  );
                },
                child: const Text(
                  "Operaciones CRUD",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          itemCount: parte.length,
          itemBuilder: (context, item) {
            return ContenedorParte(
              parte: parte[item],
            );
          },
        )
      ],
    );
  }
}

class ContenedorParte extends StatelessWidget {
  final PartesModel parte;

  ContenedorParte({
    Key? key,
    required this.parte,
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
                    builder: (context) => parteInfo(
                        nombre: parte.nombre_parte,
                        descripcion: parte.descripcion,
                        imagen_url: parte.imagen),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: parte.imagen ?? "Null",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonajeParte(indentificador: parte.nombre_parte),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parte.nombre_parte ?? "Parte Génerica",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    parte.nombre_parte ?? "Parte Genérica",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
