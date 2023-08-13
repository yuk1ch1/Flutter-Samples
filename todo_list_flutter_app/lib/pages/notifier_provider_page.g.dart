// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_provider_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListHash() => r'60503188cba6e493c7e0f786b63678160ef94b3d';

/// TODO（タスク）を保存、取得、削除、更新する Notifier(TodoList)
/// _$クラス名 を継承したクラスにアノテーションを付けることでNotifierProviderが生成される(参照: https://zenn.dev/riscait/books/flutter-riverpod-practical-introduction/viewer/how-to-choose-provider-definition)
///
/// Copied from [TodoList].
@ProviderFor(TodoList)
final todoListProvider =
    AutoDisposeNotifierProvider<TodoList, List<Todo>>.internal(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoList = AutoDisposeNotifier<List<Todo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
