// Modelo de datos para representar una nota
class Note {
  // Identificador único de la nota
  final String id;
  // Título de la nota
  String title;
  // Contenido principal de la nota
  String content;
  // Fecha de creación de la nota
  DateTime createdAt;
  // Fecha de última modificación
  DateTime modifiedAt;

  // Constructor que requiere todos los campos
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
  });

  // Añadir métodos para convertir a/desde JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        modifiedAt: DateTime.parse(json['modifiedAt']),
      );
}