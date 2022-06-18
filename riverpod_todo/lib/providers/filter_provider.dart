import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todo/providers/todolist_notifier.dart';

enum Filter {
  notCompleted,
  completed,
  all
}

final filterProvider = StateProvider<Filter>(
    (ref) => Filter.notCompleted
);

final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.isCompleted).length;
});
