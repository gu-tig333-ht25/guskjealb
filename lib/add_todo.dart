import 'package:flutter/material.dart';


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