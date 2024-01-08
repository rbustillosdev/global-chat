import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/user/data/model/exceptions/auth_exceptions.dart';
import 'package:global_chat/user/data/remote/user_data_source.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth firebaseAuth;
  final UserDataSource remote;

  const UserRepositoryImpl({required this.firebaseAuth, required this.remote});

  @override
  Future<User> doSignIn() async {
    final result = await remote.doSignIn();
    User user;

    if (result != null) {
      final authentication = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      final authCredential =
          await firebaseAuth.signInWithCredential(credential);
      user = authCredential.user!;
    } else {
      throw AuthCanceledException('');
    }
    return user;
  }

  @override
  Future<User> doSignUp(Credential userCredential) async {
    final result = await remote.doSignUp(userCredential);
    await firebaseAuth.currentUser!.updateDisplayName(userCredential.displayName);
    return result.user!;
  }

  @override
  User? getCurrentUser() => firebaseAuth.currentUser;

  @override
  Future<void> doSignOut() async => await firebaseAuth.signOut();

  @override
  Future<User> doSignInWithCredential(Credential userCredential) async {
    final result = await remote.doSignInWithCredential(userCredential);
    return result.user!;
  }

  @override
  Future<void> doDeleteAccount(Credential? userCredential) async {
    try {
      final user = firebaseAuth.currentUser;
      if (userCredential == null) {
        final result = await remote.doSignIn();
        final authentication = await result!.authentication;
        final credential = GoogleAuthProvider.credential(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);
        await user!.reauthenticateWithCredential(credential);
      } else {
        final credential = EmailAuthProvider.credential(
            email: userCredential.email, password: userCredential.password);
        await user!.reauthenticateWithCredential(credential);
      }

      await user.delete();
    } catch (e) {
      rethrow;
    }
  }

}
