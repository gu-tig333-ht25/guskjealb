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
  int _counter = 0; // to remove
  bool _checkedValue = false;

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,//Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),),
      ),
      body: Column(
        children: [
          _item("Write a book"),
          _item("Do homework"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _item(String text) {
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
                value: _checkedValue, 
                onChanged: (newValue)
                  {
                    if (newValue != null) {
                      setState(() {
                        _checkedValue = newValue;
                      });
                    }
                  }
                ),
            ),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 35, decoration: _checkedValue ? TextDecoration.lineThrough : TextDecoration.none)),
            ),
            Icon(Icons.close, size: 35),
          ],
        ),
      ),
    );
  }
}