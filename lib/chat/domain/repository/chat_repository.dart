import 'package:global_chat/chat/domain/models/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getAllMessages();
  Future<void> sendMessage(Message message);
  Future<void> deleteAllMessages();
}