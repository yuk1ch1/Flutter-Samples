import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/providers/filter_provider.dart';
import 'package:riverpod_todo/todo.dart';
import 'package:riverpod_todo/providers/todolist_notifier_provider.dart';


/// The list of todos after applying of [todoListFilter].
///
/// This too uses [Provider], to avoid recomputing the filtered list unless either
/// the filter of or the todo-list updates.
///
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(filterProvider);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case Filter.completed:
      return todos.where((todo) => todo.isCompleted).toList();
    case Filter.notCompleted:
      return todos.where((todo) => !todo.isCompleted).toList();
    case Filter.all:
      return todos;
  }
});