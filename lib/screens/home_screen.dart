import 'package:flutter/material.dart';
import '../models/note.dart';
import 'note_editor_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteAdded;
  final Function(Note) onNoteUpdated;
  final Function(Note) onNoteDeleted;
  final String appTitle;
  final Function(String) onTitleChanged;

  const HomeScreen({
    Key? key, 
    required this.notes,
    required this.onNoteAdded,
    required this.onNoteUpdated,
    required this.onNoteDeleted,
    required this.appTitle,
    required this.onTitleChanged,
  }) : super(key: key);

  void _addNote(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteEditorScreen(note: null),
      ),
    );

    if (result != null && result is Note) {
      onNoteAdded(result);
    }
  }

  void _editNote(BuildContext context, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    );

    if (result != null && result is Note) {
      onNoteUpdated(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          appTitle,  // Use the appTitle parameter instead of hardcoded text
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController titleController = 
                      TextEditingController(text: appTitle);  // Use current appTitle
                  return AlertDialog(
                    title: const Text('Cambiar título de la app'),
                    content: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Nuevo título',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          onTitleChanged(titleController.text);  // Call onTitleChanged
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay notas. ¡Crea una!',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => _editNote(context, note),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Eliminar nota'),
                                        content: const Text('¿Estás seguro de que quieres eliminar esta nota?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              onNoteDeleted(note);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                note.content,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Creado: ${_formatDate(note.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Add this helper method at the class level
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }