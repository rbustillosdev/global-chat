part of 'chat_bloc.dart';

class ChatState {
  final Stream<List<Message>> messages;
  final ChatStatus status;

  const ChatState(
      {this.messages = const Stream.empty(), this.status = ChatStatus.loading});

  const ChatState.initialState() : this();

  ChatState copyWith({Stream<List<Message>>? messages, ChatStatus? status}) {
    return ChatState(
        messages: messages ?? this.messages, status: status ?? this.status);
  }
}

enum ChatStatus { loading, success, messageSent, error, dataDeleted }
