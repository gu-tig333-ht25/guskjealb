import 'package:flutter/material.dart';
import 'add_todo.dart';
import 'todo.dart';
import 'todo_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'TIG333 TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [
    Todo(text: "Write a book"),
    Todo(text: "Do homework"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: Text(widget.title, style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),),
      ),
      body: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onToggle: () => setState(() => todo.done = !todo.done),
                onDelete: () => setState(() => todos.remove(todo)),
              );
            },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );

          if (newTodo != null && newTodo.isNotEmpty) {
            setState(() {
              todos.add(Todo(text: newTodo));
            });
          }
        },
        tooltip: 'Add new todo-item',
        child: Icon(Icons.add),
      ),
    );
  }
}
