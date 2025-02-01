import 'package:flutter/material.dart';
import '../models/note.dart';

// Pantalla para crear o editar notas
class NoteEditorScreen extends StatefulWidget {
  // Nota existente (null si es una nueva nota)
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  // Controladores para los campos de texto
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con el texto existente o vacío
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con título y botón de guardar
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota'),
        actions: [
          // En el botón de guardar del NoteEditorScreen:
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final note = Note(
                id: widget.note?.id ?? DateTime.now().toString(),
                title: _titleController.text,
                content: _contentController.text,
                createdAt: widget.note?.createdAt ?? DateTime.now(),
                modifiedAt: DateTime.now(),
              );
              Navigator.pop(context, note);
            },
          ),
        ],
      ),
      // Cuerpo del editor
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para el título
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Campo expandible para el contenido
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}