import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.title,
    required super.description,
    required super.completed,
    required super.id,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
    };
  }
}
