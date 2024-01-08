import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository repository;
  const GetCurrentUserUseCase({required this.repository});

  User? call() => repository.getCurrentUser();
}