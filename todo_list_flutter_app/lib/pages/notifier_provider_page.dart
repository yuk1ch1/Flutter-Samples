
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// @riverpod の使用は `riverpod_annotation` パッケージが必要です。
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/todo.dart';

// 忘れずに part 'ファイル名.g.dart'; を指定しましょう。
part 'notifier_provider_page.g.dart';


/// TODO（タスク）を保存、取得、削除、更新する Notifier(TodoList)
/// _$クラス名 を継承したクラスにアノテーションを付けることでNotifierProviderが生成される(参照: https://zenn.dev/riscait/books/flutter-riverpod-practical-introduction/viewer/how-to-choose-provider-definition)
@riverpod
class TodoList extends _$TodoList {

  @override
  List<Todo> build() {
    return const [];
  }

  void add(Todo todo) {
    state = [...state, todo];
  }

  void remove(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  void toggle(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id == todoId)
          todo.copyWith(completed: !todo.completed)
      else
        todo,
    ];
  }
}

// hookを使う場合はHookConsumerWidgetを継承させる
class NotifierProviderPage extends ConsumerWidget {
  const NotifierProviderPage({
    super.key,
  });

  static const String title = 'NotifierProvider';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // NotifierProviderを読み取る。watchを使用しているので、
    // state（状態）であるTODOリストが更新されると、buildメソッドが再実行されて画面が更新される
    // つまりどちらもwatchを使ってるけどあくまで監視対象はnotifierではなくてtodoListの方ってわけ？
    final todoList = ref.watch(todoListProvider);
    // TodoList(Notifier) を使用する場合は `.notifier` を付けて取得する
    // .notifierで取れるのはクラスのインスタンス？
    final todoListInstance = ref.read(todoListProvider.notifier);

    // notifierをつける場合とつけない場合のいい説明が書かれてる: https://zenn.dev/riscait/books/flutter-riverpod-practical-introduction/viewer/v1-state-provider
    // StateProviderは自動生成が現状できないみたいで、自動生成を利用したいならここで使っているNotifierProviderを使う他ないみたい
    // StateNotifierProviderも自動生成が現状できないみたい。自動生成を利用したいなら同様にNotifierProviderを使う他ないみたい
    // StateProviderと同じ機能をもつProviderは他にないが、StateNotifierProviderとNotifierProviderは同じ機能のように見える
    // 用途としてはChangeNotifierProviderも同じ

    // 新しいTodoを追加する、メソッドを定義
    void addTodo() {
      final newTodo = Todo(
        id: Random().nextDouble().toString(),
        title: DateTime.now().toIso8601String(),
      );
      // TodoList(Notifier)に定義したメソッドを使用して、新しいTodoをstateに追加する
      todoListInstance.add(newTodo);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          // ボタンを押して新しいTodoを追加できる（実際のアプリではTodoのタイトル等を入力できるようにする）
          IconButton(onPressed: addTodo, icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: todoList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final todo = todoList[index];
            return Card(
              child: ListTile(
                title: Text(todo.title),
                leading: Icon(
                  todo.completed
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
                trailing: TextButton(
                  onPressed: () => todoListInstance.remove(todo.id),
                  child: const Text('Delete'),
                ),
                // タップでTODOの完了状態を切り替える
                onTap: () => todoListInstance.toggle(todo.id),
              ),
            );
          },
        ),
      ),
    );
  }
}


