import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}


/*
part 'todo.freezed.dart';
part 'todo.g.dart';
が気になるから聞いてみた

[User]
freezedとjson_serializableはなんのために必要なの？

[ChatGPT]
freezedとjson_serializableは、FlutterおよびDartの開発者がコードの品質を向上させるために利用する2つの主要なパッケージです。それぞれの用途について詳しく説明します。

freezed:
不変性: freezedは不変のデータモデルを生成するのに役立ちます。一度作成されたインスタンスは、その後変更することはできません。
コピーヘルパー: freezedはcopyWithメソッドを提供します。これは、既存のインスタンスの一部のフィールドだけを変更して新しいインスタンスを作成するのに役立ちます。
Union Types/Sealed Classes: さまざまな型のサブクラスを持つクラスを簡単に作成するのに役立ちます。これは、特定の状態を表すためのエラーハンドリングや状態管理などに有用です。
効果的なコード生成: freezedは冗長なコードの手書きを避けるための自動生成ツールを提供します。
json_serializable:
JSON変換: json_serializableは、DartオブジェクトをJSONにシリアライズ（エンコード）し、JSONをDartオブジェクトにデシリアライズ（デコード）するためのコードを自動的に生成します。
効率: 手動でJSON変換ロジックを書くのは煩雑でエラーが発生しやすいため、このツールはそのプロセスを効率的かつ正確にします。
保守性: モデルクラスが変更された場合、変換ロジックも自動的に更新されるため、保守が容易になります。
要するに、freezedは、不変性やユニオン型を持つデータモデルの生成を容易にし、コードの安全性と保守性を向上させるためのものです。一方、json_serializableは、DartオブジェクトとJSONの間の変換を効率的に行うためのものです。



[User]
freezedはswiftでいうstructを作るためのものですか？
モデルクラスが変更された場合、変換ロジックも自動的に更新されるため、保守が容易になりますというのは再度build_runnerを実行しなくても勝手にやってくれるの？

[ChatGPT]
freezedとSwiftのstruct:
freezedを使用して作成されるクラスは、Swiftのstructに似た性質を持ちますが、完全に同じではありません。freezedは、Dartで不変のクラスを作成するためのもので、一度作成されたインスタンスは変更できません。Swiftのstructも不変性を持っており、プロパティの変更は新しいインスタンスの作成を伴います。しかし、freezedはその他にもユニオン型やシールドクラスのような機能を持っており、その点でSwiftの基本的なstructとは異なります。
モデルクラスとbuild_runner:
"モデルクラスが変更された場合、変換ロジックも自動的に更新される"というのは、json_serializableやfreezedのようなコード生成ツールの利点を指しています。しかし、これは自動的には行われません。クラスを変更した場合、その変更を反映するためにbuild_runnerを再度実行する必要があります。これにより、新しい変換ロジックやその他の生成されたコードが作成されます。このプロセスを手動で行うのは冗長ですが、コード生成ツールの利用によって、変換ロジックなどの複雑なコードを手動で書くことなく、モデルクラスの変更を迅速に反映できるという意味で保守が容易になります。
* */

// @immutable // TODO: 後でfreezedの方に修正する(以下のようなコードを作る必要がなくなるから)
// class Todo {
//   final String id;
//   final String name;
//   final bool isCompleted;
//
//   const Todo({required this.id, required this.name, required this.isCompleted});
//
//   Todo copyWith({String? id, String? name, bool? isCompleted}) {
//     return Todo(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         isCompleted: isCompleted ?? this.isCompleted);
//   }
// }