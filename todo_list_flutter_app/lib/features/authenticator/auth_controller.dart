import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final _auth = FirebaseAuth.instance;

  @override
  User? build() {
    return FirebaseAuth.instance.currentUser;
  }

  /// FirebaseAuthの匿名認証でサインインする
  Future<void> signInWithAnonymous() async {
    final userCredential = await _auth.signInAnonymously();
    state = userCredential.user;
  }

  /// アカウントを削除する
  Future<void> deleteAccount() async {
    await state?.delete();
  }

  /// Firebase Auth User の表示名を更新する
  Future<void> updateDisplayName(String newName) async {
    // await state?.updateProfile(displayName: newName);
    await state?.updateDisplayName(newName);
  }
}