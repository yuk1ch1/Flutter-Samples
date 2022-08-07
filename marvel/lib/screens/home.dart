import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:marvel/marvel_model.dart';
import 'package:marvel/repository.dart';
import 'package:marvel/src/widgets/loading_image.dart';
import 'package:marvel/src/widgets/marvel_logo.dart';
import 'package:marvel/src/widgets/search_bar.dart';

part 'home.freezed.dart';

const kCharactersPageLimit = 50;

@freezed
class CharacterPagination with _$CharacterPagination {
  factory CharacterPagination({
    required int page,
    String? name,
  }) = _CharacterPagination;
}

// 戻り値: AsyncValue<int>。charactersCountという変数の呼び出し時にはStringが引数に必要
final charactersCount =
Provider.autoDispose.family<AsyncValue<int>, String>((ref, name) { // futureProviderを監視した際の戻り値はAsyncValueになるみたい(https://riverpod.dev/ja/docs/providers/future_provider)
  // refはproviderRef,nameはここではString
  final meta = CharacterPagination(page: 0, name: name);

  // CharacterPaginationのインスタンスを渡してcharacterPagesというfutureProviderを取得してその状態を監視。値が変わったらvalue.totalCountを返す
  return ref.watch(characterPages(meta)).whenData((value) => value.totalCount);
});

class AbortedException implements Exception {}

final _characterIndex = Provider<int>((ref) => throw UnimplementedError());

// 呼び出し時にはCharacterPaginationが引数に必要。戻り値はMarvelCharacterListResponse
final characterPages = FutureProvider.autoDispose
    .family<MarvelCharacterListResponse, CharacterPagination>(
      (ref, meta) async { // refはproviderRefでmetaはここではCharacterPagination
    // Cancel the page request if the UI no longer needs it before the request
    // is finished.
    // This typically happen if the user scrolls very fast
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);

    // Debouncing the request. By having this delay, it leaves the opportunity
    // for consumers to subscribe to a different `meta` parameters. In which
    // case, this request will be aborted.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (cancelToken.isCancelled) throw AbortedException();

    final repository = ref.watch(repositoryProvider);
    final charactersResponse = await repository.fetchCharacters(
      offset: meta.page * kCharactersPageLimit,
      limit: kCharactersPageLimit,
      nameStartsWith: meta.name,
      cancelToken: cancelToken,
    );
    return charactersResponse;
  },
  // When a page is no-longer use, keep it in cache for up to 5 minutes.
  // After this point, if the list of characters is requested again, a new fetch
  // will be performed.
  cacheTime: const Duration(minutes: 5),
);

@freezed
class CharacterOffset with _$CharacterOffset {
  factory CharacterOffset({
    required int offset,
    @Default('') String name,
  }) = _CharacterOffset;
}

final characterAtIndex = Provider.autoDispose
    .family<AsyncValue<Character>, CharacterOffset>((ref, query) {
  final offsetInPage = query.offset % kCharactersPageLimit;

  final meta = CharacterPagination(
    page: query.offset ~/ kCharactersPageLimit,
    name: query.name,
  );

  return ref.watch(characterPages(meta)).whenData(
        (value) => value.characters[offsetInPage],
  );
});

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(charactersCount('')).when(
      loading: () => Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Text('$err'),
          ),
        );
      },
      data: (charactersCount) { // ここは上のref.watch(charactersCount('').whenの完了結果を見てるだけみたい。名前はなんでも良さそう)
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  title: SizedBox(
                    height: 40,
                    child: marvelLogo,
                  ),
                  centerTitle: true,
                  background: Image.asset(
                    'assets/marvel_background.jpeg',
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.multiply,
                    // color: Colors.grey.shade500,
                  ),
                  titlePadding: const EdgeInsetsDirectional.only(bottom: 8),
                ),
                pinned: true,
                actions: const [
                  SearchBar()
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, left: 3, right: 3),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8
                  ),
                  delegate: SliverChildBuilderDelegate((c, index) {
                    return ProviderScope(
                      overrides: [
                        _characterIndex.overrideWithValue(index),
                      ],
                      child: const CharacterItem(),
                    );
                  }),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/charactes/1009368'),
            label: const Text('Deep Link to Iron-man'),
            icon: const Icon(Icons.link),
          ),
        );
      },
    );
  }
}

class CharacterItem extends HookConsumerWidget {
  const CharacterItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(_characterIndex);

    final character = ref.watch(
      characterAtIndex(CharacterOffset(offset: index)),
    );

    return character.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error $err'),
      data: (character) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/characters/${character.id}');
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: 'character-${character.id}',
                    child: LoadingImage(url: character.thumbnail.url),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(character.name),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

