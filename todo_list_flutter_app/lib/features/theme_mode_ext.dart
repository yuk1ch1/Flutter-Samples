import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// FlutterにはThemeModeという使用するテーマを判別するEnumが用意されている
// テーマを選択してもらう画面で、テーマに対する説明分やアイコンを表示させたいときはThemeModeを拡張すると便利
// Text(themeMode.subtitle) や Icon(themeMode.iconData)のように使う
extension ThemeModeExt on ThemeMode {
  String get subtitle {
    switch (this) {
      case ThemeMode.system:
        return '端末のシステム設定に追従します';
      case ThemeMode.light:
        return '明るいテーマです';
      case ThemeMode.dark:
        return '暗いテーマです';
    }
  }

  IconData get iconData {
    switch (this) {
      case ThemeMode.system:
        return Icons.autorenew;
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nightlife;
    }
  }
}

//
// extension ThemeModeExt on ThemeMode {
//   String title(AppLocalizations l10n) {
//     switch (this) {
//       case ThemeMode.system:
//         return l10n.themeModeTitleSystem;flutter gen-l10n
//       case ThemeMode.light:
//         return l10n.themeModeTitleLight;
//       case ThemeMode.dark:
//         return l10n.themeModeTitleDark;
//     }
//   }
//
//   String subtitle(AppLocalizations l10n) {
//     switch (this) {
//       case ThemeMode.system:
//         return l10n.themeModeSubtitleSystem;
//       case ThemeMode.light:
//         return l10n.themeModeSubtitleLight;
//       case ThemeMode.dark:
//         return l10n.themeModeSubtitleDark;
//     }
//   }
//
//   IconData get iconData {
//     switch (this) {
//       case ThemeMode.system:
//         return Icons.autorenew;
//       case ThemeMode.light:
//         return Icons.wb_sunny;
//       case ThemeMode.dark:
//         return Icons.nightlife;
//     }
//   }
// }