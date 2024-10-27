import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await localDataSource.getTodos();
      return Right(todos);
    } catch (e) {
      return Left(CacheFailure('Unable to fetch todos from cache.'));
    }
  }

  @override
  Future<Either<Failure, void>> createTodo(Todo todo) async {
    try {
      final todos = await localDataSource.getTodos();
      final updatedTodos = List<TodoModel>.from(todos)
        ..add(TodoModel(
          id: todo.id,
          title: todo.title,
          description: todo.description,
          completed: todo.completed,
        ));
      await localDataSource.saveTodos(updatedTodos);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Unable to create todo.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodoStatus(
      String id, bool completed) async {
    try {
      final todos = await localDataSource.getTodos();
      final updatedTodos = todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: completed);
        }
        return todo;
      }).toList();
      await localDataSource.saveTodos(updatedTodos);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Unable to update todo status.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodoById(String id) async {
    try {
      final todos = await localDataSource.getTodos();
      final updatedTodos = todos.where((todo) => todo.id != id).toList();
      await localDataSource.saveTodos(updatedTodos);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Unable to delete todo.'));
    }
  }
}
