import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';

class DoSignInUseCase {
  final UserRepository repository;
  const DoSignInUseCase({required this.repository});

  Future<User> call() async => await repository.doSignIn();
  Future<User> callWithCredential(Credential userCredential) async => await repository.doSignInWithCredential(userCredential);
}