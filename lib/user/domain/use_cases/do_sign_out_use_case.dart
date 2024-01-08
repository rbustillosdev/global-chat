import 'package:global_chat/user/domain/repository/user_repository.dart';

class DoSignOutUseCase {
  final UserRepository repository;
  const DoSignOutUseCase({required this.repository});

  Future<void> call() async => await repository.doSignOut();
}