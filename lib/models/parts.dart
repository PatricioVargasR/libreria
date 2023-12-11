import 'dart:convert';

List<PartesModel> partesModelFromJson(String str) => List<PartesModel>.from(jsonDecode(str, reviver: (key, value) {
  if (value is String){
    return utf8.decode(value.codeUnits);
  }
  return value;
}).map((x) => PartesModel.fromJson(x)));

String partesModelJson(List<PartesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())), toEncodable: (value) {
  if (value is String) {
    return utf8.encode(value);
  }
  return value;
});

class PartesModel {
  PartesModel({
    required this.nombre_parte,
    required this.descripcion,
    required this.imagen
  });

  final String? nombre_parte;
  final String? descripcion;
  final String? imagen;

  factory PartesModel.fromJson(Map<String, dynamic> json) => PartesModel(
      nombre_parte: json["Nombre"],
      descripcion: json["Descripcion"],
    imagen: json["imagenes"]
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre_parte,
    "descripcion": descripcion,
    "imagen": imagen
  };
}