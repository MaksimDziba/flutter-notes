import 'package:flutter/material.dart';

import '../db/database_provide.dart';

import '../models/note_model.dart';
import '../theme/note_colors.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A;

class EditNote extends StatefulWidget {
  final args;

  const EditNote(this.args);
  _EditNote createState() => new _EditNote();
}

class _EditNote extends State<EditNote> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  bool isEditMode = false;
  NoteModel? note;

  String title = '';
  String body = '';
  String color = 'default';
  DateTime date = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    isEditMode = args?['isEditMode'] ?? false;
    note = args?['note'];

    titleController = TextEditingController();
    bodyController = TextEditingController();

    if (isEditMode) {
      titleController.text = note?.title ?? '';
      bodyController.text = note?.body ?? '';

      color = note?.color ?? 'default';
    }
  }

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

  void handleColor(currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) => ColorPalette(
        parentContext: currentContext,
      ),
    ).then((colorName) {
      if (colorName != null) {
        setState(() {
          color = colorName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(NoteColors[color]!['l']!),
      appBar: AppBar(
        backgroundColor: Color(NoteColors[color]!['b']!),
        title: Text(isEditMode ? 'Изменить заметку' : 'Новая заметка'),
        actions: [
          if (isEditMode)
            IconButton(
                onPressed: () {
                  final id = note?.id;

                  if (id != null) {
                    deleteNote(id);
                  }

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                icon: const Icon(Icons.delete)),
          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: const Color(c1),
            ),
            tooltip: 'Цвет заметки',
            onPressed: () => handleColor(context),
          ),
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
        backgroundColor: Color(NoteColors[color]!['b']!),
        label: const Text('Сохранить заметку'),
        icon: const Icon(Icons.save),
        onPressed: () {
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            date = DateTime.now();
          });

          NoteModel model = NoteModel(
              title: title, body: body, color: color, creationDate: date);

          if (isEditMode) {
            final id = note?.id;

            if (id != null) {
              model.id = id;
            }
          }

          editNote(model);

          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      ),
    );
  }
}

class ColorPalette extends StatelessWidget {
  final parentContext;

  const ColorPalette({
    super.key,
    @required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(c1),
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: MediaQuery.of(context).size.width * 0.02,
          runSpacing: MediaQuery.of(context).size.width * 0.02,
          children: NoteColors.entries.map((entry) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(entry.key),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.06),
                  color: Color(entry.value['b']!),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
