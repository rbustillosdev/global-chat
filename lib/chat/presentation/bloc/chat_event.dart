part of 'chat_bloc.dart';
sealed class ChatEvent {
  const ChatEvent();
}

final class AllMessagesRequested extends ChatEvent {}
final class MessageSendRequested extends ChatEvent {
  final Message message;
  const MessageSendRequested({required this.message});
}
final class DeleteAllMessagesRequested extends ChatEvent {}