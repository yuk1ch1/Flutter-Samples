import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/providers/shared_preference_provider.dart';

part 'theme_selector_provider.g.dart';

/// SharedPreferencesで使用するテーマ保存用キー
const _themePrefsKey = 'selectedThemeKey';

@Riverpod(keepAlive: true)
class ThemeSelector extends _$ThemeSelector {
  @override
  ThemeMode build() {
    /// 'SharedPreferences'を使用して、記憶しているテーマがあれば取得、反映する
    final pref = ref.watch(sharedPreferencesProvider);
    final themeIndex = pref.getInt(_themePrefsKey);
    if (themeIndex == null) {
      return ThemeMode.system;
    }
    final themeMode = ThemeMode.values.firstWhere(
          (e) => e.index == themeIndex,
      orElse: () => ThemeMode.system,
    );
    return themeMode;
  }

  /// 選択したテーマを保存すためのローカル保存領域
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  /// テーマの変更と保存を行う
  Future<void> changeAndSave(ThemeMode theme) async {
    await _prefs.setInt(_themePrefsKey, theme.index);
    state = theme;
  }
}


/// 上記themeSelectorProviderを利用して以下のようにすれば、ライト/ダーク切り替わる度に画面が更新されるようにする
class MyApp2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData.light(), // `.copyWith()` メソッド等で適宜カスタムしましょう。
      darkTheme: ThemeData.dark(), // `.copyWith()` メソッド等で適宜カスタムしましょう。
      themeMode: ref.watch(themeSelectorProvider), // 現在のテーマモード設定を監視
      home: Text("ダミー"),
    );
  }
}

// また上記のThemeData.lightやThemeData.darkはそのまま使ってもいいけど、
// 大体アプリごとに独自のカラーリング文字装飾を行うのでその場合は以下のように定義、その上でMaterialAppの引数のthemeやdarkThemeに設定する
// final myLightThemeData = ThemeData.from(
//   // 色の指定は `ColorScheme` を使用することが推奨されている。
//   // `DarkTheme` の方は `ColorScheme.dark()` を使用を推奨します。
//   colorScheme: const ColorScheme.light().copyWith(
//     primary: const Color(0xFFF0BC1B),
//     onPrimary: Colors.white,
//     onSecondary: Colors.white,
//   ),
//   textTheme: const TextTheme(
//     button: TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.blue,
//     ),
//   ),
// ).copyWith(
//   scaffoldBackgroundColor: const Color(0xFFF6F3F0),
//   appBarTheme: const AppBarTheme(color: Color(0xFFEEEAE1)),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     elevation: 2,
//   ),
// );
//
// final myDarkThemeData = ThemeData.from(
// ...
// );
