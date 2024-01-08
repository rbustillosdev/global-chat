import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';

class DoDeleteAccountUseCase {
  final UserRepository repository;

  const DoDeleteAccountUseCase({required this.repository});

  Future<void> call(Credential? userCredential) async =>
      await repository.doDeleteAccount(userCredential);
}
