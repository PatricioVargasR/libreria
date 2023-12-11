import 'package:flutter/material.dart';
import 'package:libreria/page/parts_page.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: paginaCarga(duracion: 3, cambiarPagina: PaginaPartes())
  ));
}

class paginaCarga extends StatelessWidget {

  int duracion = 0;

  Widget cambiarPagina;

  paginaCarga({super.key, required this.cambiarPagina, required this.duracion});

  @override
  Widget build(BuildContext context){

    Future.delayed(Duration(seconds: this.duracion), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => this.cambiarPagina)
      );
    });

    return Scaffold(
        body: Container(
            color: Colors.deepPurple,
            alignment: Alignment.center,
            child: const Icon(Icons.cached, color: Colors.white, size: 100)
        )
    );
  }
}

