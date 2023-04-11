import '../db/database_provide.dart';

import 'package:flutter/material.dart';
import '../models/note_model.dart';

class EditNote extends StatefulWidget {
  final args;

  const EditNote(this.args);
  _EditNote createState() => new _EditNote();
}

class _EditNote extends State<EditNote> {
  bool isEditMode = false;

  String title = '';
  String body = '';
  DateTime date = DateTime.now();

  editNote(NoteModel note) async {
    if (isEditMode) {
      await DatabaseProvider().update(note);
    } else {
      await DatabaseProvider().create(note);
    }

    final text = isEditMode
        ? 'Заметка успешно изменена!'
        : 'Заметка успешно добавилась!';

    print(text);
  }

  void deleteNote(int id) async {
    await DatabaseProvider().delete(id);

    print('Заметка успешно удалена!');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    bool mode = args?['isEditMode'] ?? false;
    NoteModel? note = args?['note'];

    setState(() {
      isEditMode = mode;
    });

    if (isEditMode) {
      titleController = TextEditingController(text: note!.title);
      bodyController = TextEditingController(text: note.body);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Изменить заметку' : 'Новая заметка'),
        actions: [
          if (isEditMode && note != null)
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

            NoteModel model =
                NoteModel(title: title, body: body, creationDate: date);

            if (isEditMode && note != null) {
              model.id = note.id;
            }

            editNote(model);

            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          label: const Text('Сохранить заметку'),
          icon: const Icon(Icons.save)),
    );
  }
}
