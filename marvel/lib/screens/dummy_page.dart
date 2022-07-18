import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:marvel/repository.dart';

class DummyPage extends HookConsumerWidget {
  const DummyPage({Key? key}) : super(key: key);

  Future<void> _callAPI(WidgetRef ref) async {
    final provider = ref.read(repositoryProvider);
    final result = await provider.fetchCharacters(offset: 5).then((value) => value.characters);
    print(result);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Example')),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                _callAPI(ref);
              },
              child: const Text('Call API'))),
    );
  }
}