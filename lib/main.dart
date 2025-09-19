import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'add_todo.dart';
import 'todo_item.dart';
import 'todo_album.dart';
import 'filter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Load .env Failed. ');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoAlbum()..fetchTodos(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  String getFilterText(TodoFilter filter) {
  switch (filter) {
    case TodoFilter.all:
      return 'All';
    case TodoFilter.done:
      return 'Done';
    case TodoFilter.notDone:
      return 'Not Done';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: Text(widget.title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
        actions: [
          Consumer<TodoAlbum>(
            builder: (context, album, child) {
              return PopupMenuButton<TodoFilter>(
                icon: Icon(Icons.more_vert, size: 32, color: Colors.black),
                onSelected: (filter) {
                  album.setFilter(filter);
                },
                itemBuilder: (context) => TodoFilter.values.map((filter) {
                  return PopupMenuItem(
                    value: filter,
                    child: Text(
                      getFilterText(filter),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Consumer<TodoAlbum>(
        builder: (context, album, child) {
          final shownTodos = album.filteredTodos;
          return ListView.builder(
            itemCount: shownTodos.length,
            itemBuilder: (context, index) {
              final todo = shownTodos[index];
              return TodoItem(
                todo: todo,
                onToggle: () {
                  album.toggleDone(todo);
                },
                onDelete: () {
                  album.deleteTodo(todo);
                },
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );

          if (title != null && title.isNotEmpty) {
            final album = context.read<TodoAlbum>();
            await album.postTodo(title);
          }
        },

        tooltip: 'Add new todo-item',
        child: Icon(Icons.add),
      ),
    );
  }
}
