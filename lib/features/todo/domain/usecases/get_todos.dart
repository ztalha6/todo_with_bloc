import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() async {
    return await repository.getTodos();
  }
}
