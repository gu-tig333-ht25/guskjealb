class Todo {
  String id;
  String title;
  bool done;
  
  Todo({
    required this.id, 
    required this.title, 
    required this.done
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool
    );
  }

  String getTitle() {
    return title;
  }

  String getId() {
    return id;
  }

  bool getDone() {
    return done;
  }
}