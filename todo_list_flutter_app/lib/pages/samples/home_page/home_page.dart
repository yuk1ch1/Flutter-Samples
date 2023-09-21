import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list_flutter_app/pages/samples/home_page/home_page_notifier.dart';

class HomePage2 extends ConsumerWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HomePageState
    final pageState = ref.watch(homePageNotifierProvider);
    // HomePageNotifier
    final pageNotifier = ref.watch(homePageNotifierProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: pageNotifier.resetAllCount,
        child: const Icon(Icons.exposure_zero),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Main Count ${pageState.mainCount}'),
            onTap: pageNotifier.increaseMainCount,
          ),
          ListTile(
            title: Text('Sub Count ${pageState.subCount}'),
            onTap: pageNotifier.increaseSubCount,
          ),
        ],
      ),
    );
  }
}