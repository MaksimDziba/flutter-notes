class NoteModel {
  int? id;
  String title;
  String body;
  DateTime creationDate;

  NoteModel({
    this.id,
    required this.title,
    required this.body,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'creationDate': creationDate.toString(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      creationDate: map['creationDate'],
    );
  }
}
