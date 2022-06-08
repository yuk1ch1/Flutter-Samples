import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/todo.dart';

void main() {
  runApp(ProviderScope(child: const App()));
}

final todoListProvider =
    StateNotifierProvider<ToDoListNotifier, List<Todo>>((ref) {
  return ToDoListNotifier([
    Todo(id: "1", name: "テスト", isCompleted: false),
    Todo(id: "2", name: "テスト2", isCompleted: false),
    Todo(id: "3", name: "テスト3", isCompleted: true),
    Todo(id: "4", name: "テスト", isCompleted: false),
    Todo(id: "5", name: "テスト2", isCompleted: false),
    Todo(id: "6", name: "テスト3", isCompleted: true),
    Todo(id: "7", name: "テスト", isCompleted: false),
    Todo(id: "8", name: "テスト2", isCompleted: false),
    Todo(id: "9", name: "テスト3", isCompleted: true),
    Todo(id: "10", name: "テスト", isCompleted: false),
    Todo(id: "11", name: "テスト2", isCompleted: false),
    Todo(id: "12", name: "テスト3", isCompleted: true),
    Todo(id: "14", name: "テスト", isCompleted: false),
    Todo(id: "15", name: "テスト2", isCompleted: false),
    Todo(id: "16", name: "テスト3", isCompleted: true),
    Todo(id: "17", name: "テスト", isCompleted: false),
    Todo(id: "18", name: "テスト2", isCompleted: false),
    Todo(id: "19", name: "テスト3", isCompleted: true),
    Todo(id: "20", name: "テスト", isCompleted: false),
    Todo(id: "21", name: "テスト2", isCompleted: false),
    Todo(id: "22", name: "テスト3", isCompleted: true),
    Todo(id: "23", name: "テスト", isCompleted: false),
    Todo(id: "24", name: "テスト2", isCompleted: false),
    Todo(id: "25", name: "テスト3", isCompleted: true),
  ]);
});

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "NavigatorApp", home: ToDoListView());
  }
}

class ToDoListView extends ConsumerWidget {
  const ToDoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the todo list changes
    List<Todo> todos = ref.watch(todoListProvider);
    int leftTodosCount =
        todos.where((todo) => !todo.isCompleted).toList().length;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Center(
              child: Text(
            'todos',
            style: TextStyle(
                color: Colors.purpleAccent.withOpacity(0.1),
                fontStyle: FontStyle.italic,
                fontSize: 100),
          )),
          TextField(
              decoration: const InputDecoration(
            hintText: 'what needs to be done?',
          )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
          ),
          Row(
            children: [Text('$leftTodosCount' + ' items left')],
          ),
          for (final todo in todos)
            CheckboxListTile(
              value: todo.isCompleted,
              onChanged: (value) =>
                  ref.read(todoListProvider.notifier).toggle(todo.id),
              title: Text(todo.name),
            )
        ],
      ),
    ));
  }
}
