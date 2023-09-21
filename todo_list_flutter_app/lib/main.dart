import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list_flutter_app/pages/async_notifier_provider_page.dart';
import 'package:todo_list_flutter_app/pages/consumer.dart';
import 'package:todo_list_flutter_app/pages/notifier_provider_page.dart';
import 'package:todo_list_flutter_app/pages/samples/home_page/home_page.dart';

import 'package:todo_list_flutter_app/flavor.dart';

void main() {
  // ビルド時に指定したFlavorを取得
  // String.fromEnvironment('FLAVOR')と書くことで、ビルド時に--dart-define=FLAVOR=xxxで指定したFlavorの文字列を取得できる
  // って書いてあったけど多分これはGUIでも同じなのかな？
  // final flavorString = const String.fromEnvironment('FLAVOR');
  // // enumから'flavorString'と一致するFlavorを取得
  // final flavor = Flavor.values.firstWhere((element) => element.name == flavorString);

  runApp(
      ProviderScope(
          // overrides: [
          //   // flavorProviderの値に'flavor'を入れる
          //   flavorProvider.overrideWithValue(flavor),
          // ],
          child: const MyApp()
      )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomePage2(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
