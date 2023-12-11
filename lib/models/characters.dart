import 'dart:convert';

List<PersonajesModel> personajesModelFromJson(String str) => List<PersonajesModel>.from(jsonDecode(str, reviver: (key, value) {
  if (value is String) {
    return utf8.decode(value.codeUnits);
  }
  return value;
}).map((x) => PersonajesModel.fromJson(x)));

String personajesModelJson(List<PersonajesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())), toEncodable: (value) {
  if (value is String) {
    return utf8.encode(value);
  }
  return value;
});
class PersonajesModel {
  PersonajesModel({
    required this.id_parte,
    required this.nombre_pesonaje,
    required this.stand,
    required this.referencia,
    required this.fecha_nacimiento,
    required this.nacionalidad,
    required this.imagen
  });

  final int? id_parte;
  final String? nombre_pesonaje;
  final String? stand;
  final String? referencia;
  final String? fecha_nacimiento;
  final String? nacionalidad;
  final String? imagen;

  factory PersonajesModel.fromJson(Map<String, dynamic> json) => PersonajesModel(
    id_parte: json["Identificador"],
    nombre_pesonaje: json["Nombre"],
    stand: json["Stand"],
    referencia: json["Referencia"],
    fecha_nacimiento: json["Fecha de Nacimiento"],
    nacionalidad: json["Nacionalidad"],
    imagen: json["Imagen"]
  );

  Map<String, dynamic> toJson() => {
    "categoria_personaje": id_parte,
    "nombre": nombre_pesonaje,
    "stand": stand,
    "referencia": referencia,
    "fecha_nacimiento": fecha_nacimiento,
    "nacionalidad": nacionalidad,
    "imagen": imagen
  };
}