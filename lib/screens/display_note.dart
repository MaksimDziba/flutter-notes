import '../db/database_provide.dart';

import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';

class ShowNote extends StatelessWidget {
  void deleteNote(int id) async {
    await DatabaseProvider().delete(id);
  }

  const ShowNote({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteModel note =
        ModalRoute.of(context)?.settings.arguments as NoteModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          IconButton(
              onPressed: () {
                deleteNote(note.id!);

                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(children: [
          Text(
            note.title,
            style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            note.body,
            style: const TextStyle(fontSize: 18.0),
          ),
        ]),
      ),
    );
  }
}
