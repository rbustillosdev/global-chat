import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_chat/chat/data/remote/chat_data_source.dart';
import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/domain/repository/chat_repository.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource remote;
  final UserRepository userRepository;

  const ChatRepositoryImpl(
      {required this.remote, required this.userRepository});

  @override
  Stream<List<Message>> getAllMessages() {
    return remote.getAllMessages().map((snapshot) {
      return snapshot.docs.reversed.map((doc) {
        return Message.fromMap(doc);
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(Message message) async {
    final user = userRepository.getCurrentUser();
    if (user != null) {
      remote.sendMessage(message.copyWith(
          createdDate: Timestamp.now(),
          modifiedDate: Timestamp.now(),
          sender: user.displayName ?? "",
          senderEmail: user.email ?? ""));
    }
  }

  @override
  Future<void> deleteAllMessages() async {
    final user = userRepository.getCurrentUser();
    if (user != null) {
      await remote.deleteAllMessages(user);
    }
  }
}
