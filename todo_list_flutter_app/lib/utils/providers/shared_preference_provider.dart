import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference_provider.g.dart';


// 以下からわかる通りSharedPreferencesのインスタンス取得は非同期
// void test() async  {
//   final prefs = await SharedPreferences.getInstance();
// }

// なので毎回非同期でインスタンスを取得せずに使用するためにも、Provider を使ってインスタンスをキャッシュする必要がある
// 一度取得したインスタンスは基本的には一貫して使うもののため State も必要ない。
// 変化する状態を持たないということは、一番基本的な「Provider」で十分
// final sharedPreferencesProvider =
// Provider<SharedPreferences>((_) => throw UnimplementedError());

// ただしUnimplementedErrorになるので以下の通りoverrideで上書きする
// ProviderScopeでは、 overriders パラメータを使用して、Providerやその値を上書き（差し替え）することができる。
// それを利用して、sharedPreferencesProvider の値を 非同期で取得した SharedPreferences のインスタンスに差し替える。
// これで、SharedPreferencesのインスタンスをキャッシュして使用できるようになる

// Future<void> test() async {
//   // `runApp` 関数が終わる前に何か処理を実行する場合は `ensureInitialized()` メソッドを追記する必要がある
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ProviderScope(
//       overrides: [
//         sharedPreferencesProvider.overrideWithValue(
//           // ここでインスタンス化し、Providerの値を上書きします
//           await SharedPreferences.getInstance(),
//         ),
//       ],
//       child: App(),
//     ),
//   );
// }

/// keepAlive: プロバイダが使用されなくなった場合にその状態を維持するかどうかの真偽値
/// trueであれば使われなくなっても破棄されない
/// デフォルト: false
/// chapter9参照
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

