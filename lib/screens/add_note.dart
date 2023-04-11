import '../db/database_provide.dart';

import 'package:flutter/material.dart';
import '../models/note_model.dart';

class AddNote extends StatefulWidget {
  final args;

  const AddNote(this.args);
  _AddNote createState() => new _AddNote();
}

class _AddNote extends State<AddNote> {
  String title = '';
  String body = '';
  DateTime date = DateTime.now();

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(NoteModel note) async {
    await DatabaseProvider().create(note);

    print('Заметка успешно добавилась!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новая заметка'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Введите заголовок...',
              ),
              style:
                  const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: TextField(
              controller: bodyController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Введите текст заметки...'),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              title = titleController.text;
              body = bodyController.text;
              date = DateTime.now();
            });

            NoteModel note =
                NoteModel(title: title, body: body, creationDate: date);

            addNote(note);

            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          label: const Text('Сохранить заметку'),
          icon: const Icon(Icons.save)),
    );
  }
}
