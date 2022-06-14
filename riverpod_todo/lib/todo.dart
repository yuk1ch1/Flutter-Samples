import 'package:flutter/material.dart';

@immutable // TODO: 後でfreezedの方に修正する
class Todo {
  final String id;
  final String name;
  final bool isCompleted;

  const Todo({required this.id, required this.name, required this.isCompleted});

  Todo copyWith({String? id, String? name, bool? isCompleted}) {
    return Todo(
        id: id ?? this.id,
        name: name ?? this.name,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}
