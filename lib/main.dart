import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'TIG333 TODO'),
      //home: AddTodoPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int id references [String text, bool done]
  Map<int, List<dynamic>> todos = {0:["Write a book", false], 1:["Do homework", false]};

  int _counter = 0; // TODO: remove

  // will eventually change page to the page that creates a new todo-list item. 
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
              final todo = todos[index]!; // TODO: bad, fix later
              return _item(index, todo[0] as String, todo[1] as bool);
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
              todos[todos.length] = [newTodo, false];
            });
          }
        },
        tooltip: 'Add new todo-item',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _item(int id, String text, bool complete) {
    return SizedBox(
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ), 
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Colors.black, width: 1.5),
                ),
                fillColor: WidgetStateColor.transparent,
                checkColor: Colors.black,
                value: complete, 
                onChanged: (newValue)
                  {
                    if (newValue != null) {
                      setState(() {
                        //complete = newValue;
                        todos[id]![1] = newValue; // TODO: bad, fix later
                      });
                    }
                  }
                ),
            ),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 35, decoration: complete ? TextDecoration.lineThrough : TextDecoration.none)),
            ),
            Icon(Icons.close, size: 35),
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
          }, // TODO: Make it do stuff
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
                  }, // TODO: Make it do stuff
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}