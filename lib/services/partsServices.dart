import 'dart:convert';

import 'package:libreria/utilities/const_app.dart';
import 'package:http/http.dart' as http;
import 'package:libreria/models/parts.dart';

class ParteHttpService {
  final String _url = "https://pruebaflutterid-66099e9f7071.herokuapp.com/";

  Future<List<PartesModel>> obtenerPartes() async {
    var uri = Uri.parse(_url + endPointParte);
    var response = await http.get(uri, headers: {"accept": "application/json"});

    if(response.statusCode == 200){
      print(partesModelFromJson(response.body));
      return partesModelFromJson(response.body);
    } else {
      throw(mensajeErrorParteApi);
    }
  }

  Future<void> enviarDatosParte(Map<String, dynamic> datos) async {
    var uri = Uri.parse(_url + endPointSubirPartes);
    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(datos),
    );

    if (response.statusCode == 201) {
      // Se ha creado con éxito (puedes ajustar el código según la respuesta esperada)
      print("Datos enviados con éxito");
    } else {
      print("Error al enviar datos. Código de estado: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw (mensajeErrorParteApi);
    }
  }

  Future<void> borrarParte(nombreParte) async {
    var uri = Uri.parse(_url + "borrarParte/$nombreParte");
    var response = await http.delete(uri, headers: {"accept": "application/json"});
    print(uri);

    if (response.statusCode == 200) {
      print("Parte eliminada con éxito");
    } else {
      print("Error al eliminar parte. Código de estado: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw (mensajeErrorParteApi);
    }
  }


  Future<void> actualizarDatosParte(nombreParte, Map<String, dynamic> nuevosDatos) async {
    var uri = Uri.parse(_url + "actualizar_parte/$nombreParte");
    print(uri);
    var response = await http.put(
      uri,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
      body: json.encode(nuevosDatos),
    );

    if (response.statusCode == 200) {
      // Actualización exitosa (ajustar según la respuesta esperada)
      print("Datos actualizados con éxito");
    } else {
      print("Error al actualizar datos. Código de estado: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw (mensajeErrorParteApi);
    }
  }
}



