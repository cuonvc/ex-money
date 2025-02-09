class NoteModel {
  late num? id;
  late String title;
  late String content;
  late String status;
  late String createdAt;
  late String updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

  static NoteModel empty() {
    return NoteModel(
      id: null,
      title: '',
      content: '',
      status: '',
      createdAt: '',
      updatedAt: ''
    );
  }

  static NoteModel fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt']
    );
  }

  static Map<String, dynamic> toMap(NoteModel data) {
    return {
      'id': data.id,
      'title': data.title,
      'content': data.content,
      'status': data.status,
      'createdAt': data.createdAt,
      'updatedAt': data.updatedAt,
    };
  }
}