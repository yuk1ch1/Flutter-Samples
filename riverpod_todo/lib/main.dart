import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/todo.dart';

void main() {
  runApp(ProviderScope(child: const App()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

final todoListProvider =
    StateNotifierProvider<ToDoListNotifier, List<Todo>>((ref) {
  return ToDoListNotifier([
    Todo(id: "1", name: "テスト", isCompleted: false),
    Todo(id: "2", name: "テスト2", isCompleted: false),
    Todo(id: "3", name: "テスト3", isCompleted: true),
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
    return Scaffold(
        appBar: new AppBar(
          title: new Text('ToDoList'),
        ),
        body: ListView(children: [
      for (final todo in todos)
        CheckboxListTile(
          value: todo.isCompleted,
          // when tapping on the todo, change its completed status
          onChanged: (value) =>
              ref.read(todoListProvider.notifier).toggle(todo.id),
          title: Text(todo.name),
        )
    ]));
  }
}