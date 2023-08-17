/*
State = ViewにもNotifierにも依存しないクラス

## home_page.dart(HomePage)
View = 画面

## home_page_state.dart(HomePageState)
State(Model) = 状態

## home_page_notifier.dart(HomePageNotifier)
ViewModel = 操作

*/

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    // Main Count
    @Default(0) int mainCount,

    // Sub Count
    @Default(0) int subCount,
  }) = _HomePageState;
}
