import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consumer.g.dart';

@riverpod
class Counter extends _$Counter {

  @override
  int build() {
    return 0;
  }

  void add() {
    state++;
  }
}

/// Consumerの使い方(ConsumerWidgetとは別のもの)
class HomePage extends StatelessWidget {
  const HomePage({
    super.key
  });

  // StatelessWidgetではbuildメソッドにWidgetRefを持たない
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      // Consumerで囲むことで、counterProviderが更新された時に
      // Textウィジェットだけが再buildされるようにできる
      body: Consumer(
        builder: (context, ref, child) {
          final count = ref.watch(counterProvider);
          return Text(
            '$count',
            style: TextStyle(fontSize: 36, color: Colors.red),);
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: counterProvider.no,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add)
      // ),
    );
  }

  /// showDialog()メソッド内でrefを使用したい場合などにbuilderで返すWidgetをConsumerでラップすることでref.watch等を使用することができる
  // Future<void> showTalkRoomOpeningDialog({
  //   required BuildContext context,
  //   required String partnerName,
  // }) async {
  //   await showDialog<void>(
  //     context: context,
  //     builder: (context) {
  //       return Consumer(
  //         builder: (context, ref, child) {
  //           return AlertDialog(
  //             title: Text(
  //               '$partnerNameさんとのトークルームが\n開設されました',
  //             ),
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   ref.read(topLevelTabStateProvider.notifier).state =
  //                       TopLevelTab.talk;
  //                 },
  //                 child: const Text('メッセージを送る'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Example')),
//       body: Consumer(
//         // Consumerで囲むことで、counterProviderが更新された時にTextウィジェットのみが再構築される
//         builder: (context, ref, child) {
//           // counterProviderを読み取る。
//           final count = ref.watch(counterProvider);
//           return Text('$count');
//         },
//       ),
//     );
//   }
// }