import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable // TODO: 後でfreezedの方に修正する
class Todo {
  final String id;
  final String name;
  final bool isCompleted;

  const Todo({required this.id, required this.name, required this.isCompleted});

  Todo copyWith({String? id, String? name, bool? isCompleted}) {
    return Todo(
        id: id ?? this.id,
        name: name ?? this.name,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}

class ToDoListNotifier extends StateNotifier<List<Todo>> {
  ToDoListNotifier([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  void add(Todo todo) {
    state = [...state, todo];
  }

  void remove(String todoId) {
    state = state.where((todo) => todo.id != todoId).toList();
  }

  void toggle(String todoId) {
    state = state.map((todo) {
      if (todo.id == todoId) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      } else {
        return todo;
      }
    }).toList();
  }
}
