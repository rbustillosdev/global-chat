import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';

class DoSignUpUseCase {
  final UserRepository repository;

  const DoSignUpUseCase({required this.repository});

  Future<User> call(Credential userCredential) async =>
      await repository.doSignUp(userCredential);
}
