import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Todo {
  String text;
  bool done = false;
  
  Todo({required this.text});
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

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Colors.black, width: 1.5),
                ),
                fillColor: WidgetStateColor.transparent,
                checkColor: Colors.black,
                value: todo.done,
                onChanged: (_) => onToggle(),
              ),
            ),
            Expanded(
              child: Text(
                todo.text,
                style: TextStyle(
                  fontSize: 35,
                  decoration: todo.done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            IconButton(
              tooltip: "Delete",
              onPressed: onDelete,
              icon: const Icon(Icons.close, size: 35),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTodoPage extends StatelessWidget {
  AddTodoPage({super.key});
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 32,),
          tooltip: 'Go back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("TIG333 TODO", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), // TODO: Fix the uglyness of this and the row below
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2.5),
                ),
                hintText: 'What are you going to do?',
              ),
            ),
            SizedBox(height: 50), // TODO: Ugly, fix this
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.add, color: Colors.black, size: 28,),
                  label: Text('ADD', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black)),
                  onPressed: () {
                    final text = textController.text.trim();
                    if (text.isNotEmpty) {
                      Navigator.pop(context, text);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}