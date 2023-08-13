import 'package:flutter/material.dart';
import 'dart:math';

// @riverpodの使用は`riverpod_annotation`パッケージが必要です
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list_flutter_app/entities/todo.dart';
import 'package:todo_list_flutter_app/utils/util.dart';

// riverpod_generatorを使ってproviderを自動生成するので忘れずにpart `ファイル名.g.dart`; を指定する
part 'async_notifier_provider_page.g.dart';

/// _$クラス名 を継承したクラスにアノテーションを付けることでProviderが生成される(参照: https://zenn.dev/riscait/books/flutter-riverpod-practical-introduction/viewer/how-to-choose-provider-definition)
@riverpod
class AsyncTodoList extends _$AsyncTodoList {
// クラスない変数としてbuildメソッドで得た値を保持させたい場合はlateを使用できる
// buildメソッドが再実行される可能性があるためfinalは使用できない
// late String value;

  Future<List<Todo>> _fetchTodo() async {
    // Web API等を通じてTodoリストを取得する処理
    final response = await dio.get<List<Map<String, Object?>>>(
      'https://example.com/api/todo',
    );
    return response.data.map(Todo.fromJson).toList();
  }

  @override
  FutureOr<List<Todo>> build() async {
    // 他のプロバイダを使用したい場合は以下のように呼び出せる
    // todoListProviderがリフレッシュされる時、TodoListクラスは再生成されないが
    // buildメソッドが再実行される
    // value = ref.watch(dependProvider);

    // 初期値としてTodoリストを取得する
    return _fetchTodo();
  }

// 新しいTODOを追加するメソッド
  Future<void> add(Todo todo) async {
    // stateをローディング状態にする
    state = const AsyncValue.loading();
    // AsyncValue.guard: 例外発生時はAsyncErrorを返してくれる(try/catchの代替)
    state = await AsyncValue.guard(() async {
      await dio.post<Map<String, Object?>>(
        'https://example.com/api/todo',
        data: todo.toJson(),
      );
      // Add後のTodoリストを再読み込み
      return _fetchTodo();
    });
  }

// IDを指定して、TODOを削除するメソッド
  Future<void> remove(String todoId) async {
    // stateをローディング状態にする
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await dio.delete<Map<String, Object?>>(
        'https://example.com/api/todo/$todoId',
      );
      return _fetchTodo();
    });
  }

  Future<void> toggle(String todoId) async {
    final todo = state.value!.firstWhere((todo) => todo.id == todoId);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await dio.patch<Map<String, Object?>>(
          'https://example.com/api/todo/$todoId',
          data: <String, Object?>{'completed': !todo.completed}
      );
      return _fetchTodo();
    });
  }
}

class AsyncNotifierProviderPage extends ConsumerWidget {
  const AsyncNotifierProviderPage({
    super.key
  });

  static const String title = 'AsyncNotifierProvider';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncNotifierProviderを読み取る。watchを使用しているので
    // state(状態)であるTODOリストが更新されるとbuildメソッドが再実行されて画面が更新される
    final asyncTodoList = ref.watch(asyncTodoListProvider);

    // AsyncTodoList(Notifier)を使用する場合は.notifierをつけて取得する
    final notifier = ref.watch(asyncTodoListProvider.notifier);

    // 新しいTodoを追加する、メソッドを定義
    Future<void> addTodo() async {
      final newTodo = Todo(
          id: Random().nextDouble().toString(),
          title: DateTime.now().toIso8601String()
      );
      // AsyncTodoList(Notifier)に定義したメソッドを使用して、新しいTodoをstateに追加する
      await notifier.add(newTodo);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          // ボタンを教えて新しいTodoを追加できる(実際のアプリではTodoのタイトル等を入力できるようにする)
          IconButton(onPressed: addTodo, icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
          child: asyncTodoList.when(
              data: (todoList) {
                return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final todo = todoList[index];
                      return Card(
                        child: ListTile(
                          title: Text(todo.title),
                          leading: Icon(
                              todo.completed
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank
                          ),
                          trailing: TextButton(
                            onPressed: () async => notifier.remove(todo.id),
                            child: const Text('Delete'),
                          ),
                          // タップでTODOの完了状態を切り替える
                          onTap: () async => notifier.toggle(todo.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemCount: todoList.length
                );
              },
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator())
          )
      ),
    );
  }
}