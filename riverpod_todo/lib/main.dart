import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/todo.dart';
import 'package:riverpod_todo/providers/todolist_notifier.dart';

void main() {
  runApp(ProviderScope(child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "NavigatorApp", home: ToDoListView());
  }
}

class ToDoListView extends ConsumerWidget {
  ToDoListView({Key? key}) : super(key: key);
  final _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

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
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'what needs to be done?',
              ),
              onSubmitted: (String text) {
                ref.read(todoListProvider.notifier).add(text);
                clearText();
              }),
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
