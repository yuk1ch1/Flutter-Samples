import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/providers/filter_provider.dart';
import 'package:riverpod_todo/todo.dart';
import 'package:riverpod_todo/providers/todolist_notifier_provider.dart';
import 'package:riverpod_todo/providers/filter_todos_provider.dart';

final allFilterKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();

void main() {
  runApp(const ProviderScope(child: App()));
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
    List<Todo> todos = ref.watch(filteredTodosProvider);

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
          const Toolbar(),
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

class Toolbar extends ConsumerWidget {
  const Toolbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    Color? textColorFor(Filter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(uncompletedTodosCount).toString()} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            key: allFilterKey,
            message: 'All todos',
            child: TextButton(
              onPressed: () =>
                  ref.read(filterProvider.notifier).state = Filter.all,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                    MaterialStateProperty.all(textColorFor(Filter.all)),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed: () =>
                  ref.read(filterProvider.notifier).state = Filter.notCompleted,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(Filter.notCompleted),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed todos',
            child: TextButton(
              onPressed: () =>
                  ref.read(filterProvider.notifier).state = Filter.completed,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(Filter.completed),
                ),
              ),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}
