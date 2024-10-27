part of 'todo_bloc.dart';

abstract class TodoEvent {}

class GetTodosEvent extends TodoEvent {}

class CreateTodoEvent extends TodoEvent {
  final String title;
  final String description;

  CreateTodoEvent(this.title, this.description);
}

class UpdateTodoStatusEvent extends TodoEvent {
  final String id;
  final bool completed;

  UpdateTodoStatusEvent(this.id, this.completed);
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent(this.id);
}
