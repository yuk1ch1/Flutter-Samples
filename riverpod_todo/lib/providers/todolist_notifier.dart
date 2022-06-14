import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:riverpod_todo/todo.dart';

const _uuid = Uuid();

class ToDoListNotifier extends StateNotifier<List<Todo>> {
  ToDoListNotifier([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  void add(String name) {
    state = [...state, Todo(id: _uuid.v4(), name: name, isCompleted: false)];
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

final todoListProvider =
    StateNotifierProvider<ToDoListNotifier, List<Todo>>((ref) {
  return ToDoListNotifier([
    Todo(id: "1", name: "テスト1", isCompleted: false),
    Todo(id: "2", name: "テスト2", isCompleted: false),
    Todo(id: "3", name: "テスト3", isCompleted: true),
    Todo(id: "4", name: "テスト4", isCompleted: false),
    Todo(id: "5", name: "テスト5", isCompleted: false),
    Todo(id: "6", name: "テスト6", isCompleted: true),
    Todo(id: "7", name: "テスト7", isCompleted: false),
    Todo(id: "8", name: "テスト8", isCompleted: false),
    Todo(id: "9", name: "テスト9", isCompleted: true),
    Todo(id: "10", name: "テスト10", isCompleted: false),
  ]);
});
