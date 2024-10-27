// features/todos/domain/repositories/todo_repository.dart
import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, void>> createTodo(Todo todo);
  Future<Either<Failure, void>> updateTodoStatus(String id, bool completed);
  Future<Either<Failure, void>> deleteTodoById(String id);
}
