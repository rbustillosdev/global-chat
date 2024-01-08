import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/domain/repository/chat_repository.dart';

class DoDeleteAllMessagesUseCase {

  final ChatRepository repository;

  const DoDeleteAllMessagesUseCase({required this.repository});

  Future<void> call() async => await repository.deleteAllMessages();
}