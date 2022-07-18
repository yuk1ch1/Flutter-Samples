import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:marvel/marvel_model.dart';
import 'package:marvel/configuration.dart';

// providerはある状態(ステート)をラップするためのオブジェクト。その状態(ステート)の値の取得や監視を行えるようにできる
final dioProvider = Provider((ref) => Dio());
final repositoryProvider = Provider((ref) => MarvelRepository(ref.read));

class MarvelRepository {
  MarvelRepository(
      this._read, {
        int Function()? getCurrentTimestamp,
      }) : _getCurrentTimestamp = getCurrentTimestamp ??
      (() => DateTime.now().millisecondsSinceEpoch);

  // 任意のタイミングでreadで値を取得するためにクラスプロパティとして定義
  final Reader _read;
  final int Function() _getCurrentTimestamp;
  final _characterCache = <String, Character>{};

  Future<MarvelCharacterListResponse> fetchCharacters({
    required int offset,
    int? limit,
    String? nameStartsWith,
    CancelToken? cancelToken,
  }) async {
    final cleanNameFilter = nameStartsWith?.trim();

    final response = await _get(
      'characters',
      queryParameters: <String, Object?>{
        'offset': offset,
        if (limit != null) 'limit': limit,
        if (cleanNameFilter != null && cleanNameFilter.isNotEmpty)
          'nameStartsWith': cleanNameFilter,
      },
      cancelToken: cancelToken,
    );

    final result = MarvelCharacterListResponse(
      characters: response.data.results.map((e) {
        return Character.fromJson(e);
      }).toList(growable: false),
      totalCount: response.data.total,
    );

    for (final character in result.characters) {
      _characterCache[character.id.toString()] = character;
    }

    return result;
  }

  Future<Character> fetchCharacter(
      String id, {
        CancelToken? cancelToken,
      }) async {
    // Don't fetch the Character if it was already obtained previously, either
    // in the home page or in the detail page.
    if (_characterCache.containsKey(id)) {
      return _characterCache[id]!;
    }

    final response = await _get('characters/$id', cancelToken: cancelToken);
    return Character.fromJson(response.data.results.single);
  }

  Future<MarvelResponse> _get(
      String path, {
        Map<String, Object?>? queryParameters,
        CancelToken? cancelToken,
      }) async {
    // privatekeyとpublickeyを取得
    final configs = await _read(configurationsProvider.future);

    final timestamp = _getCurrentTimestamp();

    // 取得した日時とprivatekey、publickeyをMD5にハッシュ変換して暗号化
    final hash = md5
        .convert(
      utf8.encode('$timestamp${configs.privateKey}${configs.publicKey}'),
    ).toString();

    // dioはswiftでいうところのURLSessionかな。だからここで通信を行っているっぽい
    final result = await _read(dioProvider).get<Map<String, Object?>>(
      'https://gateway.marvel.com/v1/public/$path',
      cancelToken: cancelToken,
      queryParameters: <String, Object?>{
        'apikey': configs.publicKey,
        'ts': timestamp,
        'hash': hash,
        ...?queryParameters,
      },
      // TODO deserialize error message
    );
    return MarvelResponse.fromJson(Map<String, Object>.from(result.data!));
  }
}