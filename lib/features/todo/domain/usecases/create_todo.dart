import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class CreateTodo {
  final TodoRepository repository;

  CreateTodo(this.repository);

  Future<Either<Failure, void>> call(Todo todo) async {
    return await repository.createTodo(todo);
  }
}
