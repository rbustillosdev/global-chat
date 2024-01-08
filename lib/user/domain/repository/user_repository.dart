import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/user/domain/model/credential.dart';

abstract class UserRepository {
  User? getCurrentUser();
  Future<User> doSignIn();
  Future<User> doSignUp(Credential userCredential);
  Future<User> doSignInWithCredential(Credential userCredential);
  Future<void> doSignOut();
  Future<void> doDeleteAccount(Credential? userCredential);
}