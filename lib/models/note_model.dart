class Note {
  String title;
  String description;
  DateTime createdAt;
  DateTime modifiedAt;

  Note({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.modifiedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }
}