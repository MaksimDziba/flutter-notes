import 'package:flutter/material.dart';

import './db/database_provide.dart';
import './models/note_model.dart';

import 'package:flutter_notes/screens/add_note.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/AddNote': (context) => AddNote(context),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<NoteModel>> getAllNotes() async {
    List<NoteModel> notes = await DatabaseProvider().getAllNotes();

    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      body: FutureBuilder(
        future: getAllNotes(),
        builder: (context, AsyncSnapshot<List<NoteModel>> noteData) {
          if (noteData.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (noteData.hasError) {
            return Center(child: Text('Ошибка: ${noteData.error}'));
          } else if (noteData.data!.isEmpty) {
            return const Center(child: Text('Нет заметок'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: noteData.data!.length,
                itemBuilder: (context, index) {
                  final note = noteData.data![index];

                  int? id = note.id;
                  String title = note.title;
                  String body = note.body;
                  DateTime creationDate = note.creationDate;

                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/AddNote', arguments: {
                          'isEditMode': true,
                          'note': NoteModel(
                              id: id,
                              title: title,
                              body: body,
                              creationDate: creationDate),
                        });
                      },
                      title: Text(title),
                      subtitle: Text(body),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final emptyNote =
              NoteModel(title: '', body: '', creationDate: DateTime.now());

          Navigator.pushNamed(context, '/AddNote',
              arguments: {'isEditMode': false, 'note': emptyNote});
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
