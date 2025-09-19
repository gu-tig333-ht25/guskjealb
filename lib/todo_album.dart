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

  Future<void> fetchTodos() async { // TODO: make function better
  print(todos);

    final uri = Uri.parse('$url/todos?key=$key');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      todos
        ..clear()
        ..addAll(jsonList.map((j) => Todo.fromJson(j as Map<String, dynamic>)));
      notifyListeners();
    } else {
      throw Exception('Fetch Failed');
    }
  }

  Future<Todo> postTodo(String title) async { // TODO: make function better
    final uri = Uri.parse('$url/todos?key=$key');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': title, 'done': false}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);

      Map<String, dynamic> json;

      if (body is List) {
        // take first element if API returns a list
        json = Map<String, dynamic>.from(body.first as Map);
      } else if (body is Map) {
        json = Map<String, dynamic>.from(body);
      } else {
        throw Exception('Unexpected response format: ${body.runtimeType}');
      }

      final todo = Todo.fromJson(json);
      await fetchTodos();
      return todo;
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