import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service_locator.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';
import '../bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(
        getTodos: GetTodos(sl()),
        createTodo: CreateTodo(sl()),
        updateTodo: UpdateTodo(sl()),
        deleteTodo: DeleteTodo(sl()),
      ),
      child: BlocBuilder<TodoBloc, TodoState>(builder: (blocContext, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo List'),
          ),
          body: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoLoaded) {
                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];
                    return Card(
                      child: ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: Checkbox(
                          value: todo.completed,
                          onChanged: (value) {
                            context
                                .read()<TodoBloc>(context)
                                .add(UpdateTodoStatusEvent(todo.id, value!));
                          },
                        ),
                        onLongPress: () {
                          context
                              .read()<TodoBloc>(context)
                              .add(DeleteTodoEvent(todo.id));
                        },
                      ),
                    );
                  },
                );
              } else if (state is TodoError) {
                return Center(child: Text(state.message));
              } else if (state is TodoEmpty) {
                return const Center(child: Text('No Todos'));
              }
              return const Center(child: Text('Unexpected Error'));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateTodoDialog(context, blocContext),
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }

  void _showCreateTodoDialog(BuildContext context, BuildContext blocContext) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                blocContext.read()<TodoBloc>(blocContext).add(
                      CreateTodoEvent(
                          titleController.text, descriptionController.text),
                    );
                Navigator.of(context).pop();
                titleController.clear();
                descriptionController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
