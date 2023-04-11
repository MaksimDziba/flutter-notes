class NoteModel {
  int? id;
  String title;
  String body;
  String color;
  DateTime creationDate;

  NoteModel({
    this.id,
    required this.title,
    required this.body,
    required this.color,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'color': color,
      'creationDate': creationDate.toString(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      color: map['color'],
      creationDate: map['creationDate'],
    );
  }
}
