import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Flavorを使うと、開発環境・テスト環境・本番環境というようにアプリの環境を変化させることが可能
enum Flavor {
  development,
  staging,
  production,
}

// 拡張して、文字列を返すGetterを用意しておくと、何かと便利です。
// （Dart 2.15以降では標準機能としてextensionが追加される予定なので追加の必要はありません）
extension FlavorExt on Flavor {
  String get name => describeEnum(this);
}

// Flavorはアプリビルド時や起動時に指定するものであり、基本的にアプリ内で変えるものではありません。
// なので、変化する状態を持たない、一番基本的な「Provider」を使用します。
// final flavorProvider = Provider<Flavor>((ref) => throw UnimplementedError());
// 上記のように一旦UnimplementErrorにするのもありだけど、環境だし以下のようにデフォルトでdevelopmentにした方が自然かも
final flavorProvider = Provider((ref) => Flavor.development);

// これの使い方
// main関数でFlavorを受け取り、 flavorProvider の値を上書きする
// 詳細はmain関数を参照