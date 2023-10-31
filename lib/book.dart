class Book {
  int? controlNum;
  String? isbn;
  String? titulo;
  String? autor;
  String? editorial;
  String? paginas;
  String? edicion;
  String? photoName;

  Book({this.controlNum, this.isbn, this.titulo, this.autor,
  this.editorial, this.paginas, this.edicion, this.photoName});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'controlNum': controlNum,
      'isbn': isbn,
      'titulo':titulo,
      'autor':autor,
      'editorial':editorial,
      'paginas':paginas,
      'edicion':edicion,
      'photo_name':photoName
    };
    return map;
  }

  Book.formMap(Map<String, dynamic> map){
      controlNum = map['controlNum'];
      isbn = map['isbn'];
      titulo = map['titulo'];
      autor = map['autor'];
      editorial = map['editorial'];
      paginas = map['paginas'];
      edicion = map['edicion'];
      photoName = map['photo_name'];

  }

}