import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/domain/repository/chat_repository.dart';

class GetAllMessagesUseCase {

  final ChatRepository repository;

  const GetAllMessagesUseCase({required this.repository});

  Stream<List<Message>> call() {
    return repository.getAllMessages();
  }
}