import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/domain/repository/chat_repository.dart';

class DoSendMessageUseCase {
  final ChatRepository repository;
  const DoSendMessageUseCase({required this.repository});

  Future<void> call(Message message) async => await repository.sendMessage(message);
}