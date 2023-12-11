import 'package:libreria/utilities/const_app.dart';
import 'package:http/http.dart' as http;
import 'package:libreria/models/characters.dart';

class personajeHttpService {
  final String _url = "https://pruebaflutterid-66099e9f7071.herokuapp.com/";

  Future<List<PersonajesModel>> obtenerPersonajes(indentificador) async {
    var uri = Uri.parse(_url + endPointPersonaje + indentificador);
    var response = await http.get(uri, headers: {"accept": "application/json"});

    if(response.statusCode == 200){
      print(personajesModelFromJson(response.body));
      return personajesModelFromJson(response.body);
    } else {
      throw(mensajeErrorPersonajesApi);
      //throw "Error en la solicitud: ${response.statusCode}, ${response.body}";
    }
  }

}
