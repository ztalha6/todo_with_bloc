import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final CreateTodo createTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  TodoBloc({
    required this.getTodos,
    required this.createTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<GetTodosEvent>((event, emit) async {
      emit(TodoLoading());
      final failureOrTodos = await getTodos();
      emit(_mapFailureOrTodosToState(failureOrTodos));
    });

    on<CreateTodoEvent>((event, emit) async {
      final todo = Todo(
        title: event.title,
        description: event.description,
        completed: false,
        id: const Uuid().v1(),
      );
      await createTodo(todo);
      add(GetTodosEvent());
    });

    on<UpdateTodoStatusEvent>((event, emit) async {
      await updateTodo(event.id, event.completed);
      add(GetTodosEvent());
    });

    on<DeleteTodoEvent>((event, emit) async {
      await deleteTodo(event.id);
      add(GetTodosEvent());
    });
  }

  TodoState _mapFailureOrTodosToState(
      Either<Failure, List<Todo>> failureOrTodos) {
    return failureOrTodos.fold(
      (failure) => TodoError(_mapFailureToMessage(failure)),
      (todos) => todos.isEmpty ? TodoEmpty() : TodoLoaded(todos),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return "Server Failure";
    } else if (failure is CacheFailure) {
      return "Cache Failure";
    } else {
      return "Unexpected Error";
    }
  }
}
