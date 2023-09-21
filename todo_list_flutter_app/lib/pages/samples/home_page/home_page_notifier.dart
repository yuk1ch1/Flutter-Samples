/*
Stateの操作を行うクラス？
余談: ViewModelではサービスクラスやリポジトリなど他のクラスとやりとりすることも少なくない

## home_page.dart(HomePage)
View = 画面

## home_page_state.dart(HomePageState)
State(Model) = 状態

## home_page_notifier.dart(HomePageNotifier)
ViewModel = 操作
* */

// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'home_page_state.dart';

part 'home_page_notifier.g.dart';

@riverpod
class HomePageNotifier extends _$HomePageNotifier{

  @override
  /// ここでproviderの初期状態を決める
  /// 今回は起動時はmainもsubも0でいいので0にしてあるけどアプリの要件次第で変更の必要あり
  HomePageState build() {
    return const HomePageState();
  }

  void increaseMainCount() {
    state = HomePageState(
      mainCount: state.mainCount + 1,
      subCount: state.subCount,
    );
  }

  void increaseSubCount() {
    state = HomePageState(
      mainCount: state.mainCount,
      subCount: state.subCount + 1,
    );
  }

  void resetAllCount() {
    state = const HomePageState(mainCount: 0, subCount: 0);
  }
}

//以下がzennで公開されていたサンプルコードだけどもはやStateNotifierProviderよりもNoifierProviderが推奨されているため不採用
// // StateNotifierProvierが持つState(状態クラス)にHomePageStateを指定
// class HomePageNotifier2 extends StateNotifier<HomePageState> {
//   HomePageNotifier2() : super;
//   // Reader 型をフィールドに持っておくことで、HomePageNotifierから他のProviderを読み取ることができるようになります
//   // 他のProviderにアクセスするために必要
//
//   // メインカウントを+1する
//   void increaseMainCount() {
//     state = state.copyWith(mainCount: state.mainCount + 1);
//   }
//
//   // サブカウントを+1する
//   void increaseSubCount() {
//     state = state.copyWith(subCount: state.subCount + 1);
//   }
//
//   // すべてのカウントを0に戻す
//   void resetAllCount() async {
//     state = state.copyWith(
//       mainCount: 0,
//       subCount: 0,
//     );
//   }
// }
// final homePageStateProvider2 =
// StateNotifierProvider.autoDispose<HomePageNotifier2, HomePageState>((ref) {
//   // Reader を渡しています（不要なら省略可能）
//   // 不要そうなので削除
//   return HomePageNotifier2();
// });