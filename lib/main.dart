import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/home_screen.dart';
import 'models/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Notas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesApp(),
    );
  }
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final List<Note> _notes = [];
  static const String _storageKey = 'notes';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_storageKey) ?? [];
    setState(() {
      _notes.clear();
      _notes.addAll(
        notesJson.map((noteStr) => Note.fromJson(jsonDecode(noteStr))).toList(),
      );
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = _notes
        .map((note) => jsonEncode(note.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, notesJson);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      notes: _notes,
      onNoteAdded: (Note note) {
        setState(() {
          _notes.add(note);
          _saveNotes();
        });
      },
      onNoteUpdated: (Note note) {
        setState(() {
          final index = _notes.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            _notes[index] = note;
            _saveNotes();
          }
        });
      },
      onNoteDeleted: (Note note) {
        setState(() {
          _notes.removeWhere((n) => n.id == note.id);
          _saveNotes();
        });
      },
    );
  }
}