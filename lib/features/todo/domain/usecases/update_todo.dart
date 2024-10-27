// features/todos/domain/usecases/update_todo.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<Either<Failure, void>> call(String id, bool completed) async {
    return await repository.updateTodoStatus(id, completed);
  }
}
