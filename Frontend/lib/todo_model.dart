class Todo {
  final int? id;
  final String title;
  final bool completed;

  Todo({this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'title': title, 'completed': completed};
  }
}
