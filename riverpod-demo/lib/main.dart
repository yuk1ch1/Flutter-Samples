import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// 状態管理表示部分(Model)
final counterProvider = ChangeNotifierProvider<CountModel>((ref) => CountModel());

class CountModel extends ChangeNotifier {
  int state = 0;

  void incrementCounter() {
    state++;
    notifyListeners();
  }
}

// 表示部分
class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod テスト'),
      ),
      body: Center(
        child: Consumer(builder: (context, watch, _) {
          // データを取得する
          final counter = ref.watch(counterProvider).state;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('クリック回数'),
              // 取得したデータを表示する
              Text(
                '$counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        // **AVOID** calling [read] inside build if the value is used only for events:
        // **CONSIDER** calling [read] inside event handlers:
        onPressed: ref.read(counterProvider).incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}