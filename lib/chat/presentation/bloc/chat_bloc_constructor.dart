import 'package:get_it/get_it.dart';
import 'package:global_chat/chat/domain/use_cases/do_delete_all_messages_use_case.dart';
import 'package:global_chat/chat/domain/use_cases/do_send_message_use_case.dart';
import 'package:global_chat/chat/domain/use_cases/get_all_Messages_use_case.dart';
import 'package:global_chat/chat/presentation/bloc/chat_bloc.dart';

ChatBloc chatBlocConstructor() => ChatBloc(
    getAllMessagesUseCase: GetIt.instance<GetAllMessagesUseCase>(),
    doSendMessageUseCase: GetIt.instance<DoSendMessageUseCase>(),
    doDeleteAllMessagesUseCase: GetIt.instance<DoDeleteAllMessagesUseCase>());
