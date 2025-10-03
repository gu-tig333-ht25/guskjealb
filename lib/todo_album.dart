import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'todo.dart';
import 'filter.dart';

class TodoAlbum extends ChangeNotifier {
  final String key = dotenv.env['API_KEY']!;
  final String url = dotenv.env['API_URL']!;
  TodoFilter filter = TodoFilter.all;

  final List<Todo> todos = [];

  // is called after every api-call to make sure we have the latest updates all the time. 
  Future<void> fetchTodos() async {

    final uri = Uri.parse('$url/todos?key=$key');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      // response body will be the list of todos, so save them locally
      todos
        ..clear()
        ..addAll(jsonList.map((j) => Todo.fromJson(j as Map<String, dynamic>)));

      notifyListeners();
    } else {
      throw Exception('Fetch Failed');
    }
  }

  void postTodo(String title) async {
    final uri = Uri.parse('$url/todos?key=$key');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': title, 'done': false}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      await fetchTodos();
    } else {
      throw Exception('Post Failed');
    }
  }

  void deleteTodo(Todo todo) async {
    String id = todo.getId();
    final uri = Uri.parse('$url/todos/$id?key=$key');
    final response = await http.delete(uri);

    if (!(response.statusCode == 201 || response.statusCode == 200)) {
      throw Exception('Delete Failed');
    }

    await fetchTodos();
  }

  void toggleDone(Todo todo) async {
    String id = todo.getId();
    String title = todo.getTitle();
    bool done = todo.getDone();
    final uri = Uri.parse('$url/todos/$id?key=$key');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id': id, 'title': title, 'done': !done}),
    );

    if (!(response.statusCode == 200 || response.statusCode == 201)) {
      throw Exception('Update Failed');
    }

    await fetchTodos();
  }

   void setFilter(TodoFilter newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.done:
        return todos.where((t) => t.done).toList();
      case TodoFilter.notDone:
        return todos.where((t) => !t.done).toList();
      default:
        return todos;
    }
  }

}