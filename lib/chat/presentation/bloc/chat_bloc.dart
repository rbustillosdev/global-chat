import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/domain/use_cases/do_delete_all_messages_use_case.dart';
import 'package:global_chat/chat/domain/use_cases/do_send_message_use_case.dart';
import 'package:global_chat/chat/domain/use_cases/get_all_Messages_use_case.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllMessagesUseCase getAllMessagesUseCase;
  final DoSendMessageUseCase doSendMessageUseCase;
  final DoDeleteAllMessagesUseCase doDeleteAllMessagesUseCase;

  ChatBloc(
      {required this.getAllMessagesUseCase,
      required this.doSendMessageUseCase,
      required this.doDeleteAllMessagesUseCase})
      : super(const ChatState.initialState()) {
    on<MessageSendRequested>(_onMessageSendRequested);
    on<DeleteAllMessagesRequested>(_onDeleteAllMessagesRequested);
    on<AllMessagesRequested>(_onGetMessagesRequested);
  }

  void _onGetMessagesRequested(
      AllMessagesRequested event, Emitter<ChatState> emitter) {
    emitter(state.copyWith(status: ChatStatus.loading));
    try {
      final stream = getAllMessagesUseCase();
      emitter(state.copyWith(status: ChatStatus.success, messages: stream));
    } catch (e) {
      emitter(state.copyWith(status: ChatStatus.error));
    }
  }

  Future<void> _onMessageSendRequested(
      MessageSendRequested event, Emitter<ChatState> emitter) async {
    try {
      await doSendMessageUseCase(event.message);
      await Future.delayed(const Duration(milliseconds: 500)).then(
          (value) => emitter(state.copyWith(status: ChatStatus.messageSent)));
    } catch (e) {
      emitter(state.copyWith(status: ChatStatus.error));
    }
  }

  Future<void> _onDeleteAllMessagesRequested(
      DeleteAllMessagesRequested event, Emitter<ChatState> emitter) async {
    emitter(state.copyWith(status: ChatStatus.loading));
    try {
      await doDeleteAllMessagesUseCase();
      emitter(state.copyWith(status: ChatStatus.dataDeleted));
    } catch (e) {
      emitter(state.copyWith(status: ChatStatus.error));
    }
  }
}
