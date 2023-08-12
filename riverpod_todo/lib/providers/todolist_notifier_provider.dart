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

// Riverpod ver2ではStateNotifierProviderではなくてNotifierProvierとAsyncNotifierProviderの利用が推奨されてるみたい
// NotifierProvider は、 State (状態) と、それを操作する Notifier を提供するためのプロバイダ
// 以下の用途で使用します。
// - 時間の経過とともに変化する可能性のある状態を公開する。
// - 長期的な保守性を向上させるために、状態を操作する非同期ビジネスロジックを一箇所に集中させる
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

final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.isCompleted).length;
});


