// features/todos/data/datasources/todo_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> saveTodos(List<TodoModel> todos);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  static const String todosKey = 'TODOS_KEY';
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TodoModel>> getTodos() async {
    final jsonString = sharedPreferences.getString(todosKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => TodoModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    final jsonString = json.encode(todos.map((todo) => todo.toJson()).toList());
    await sharedPreferences.setString(todosKey, jsonString);
  }
}
