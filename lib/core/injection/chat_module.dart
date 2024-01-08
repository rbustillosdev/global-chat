import 'package:get_it/get_it.dart';
import 'package:global_chat/chat/data/remote/chat_data_source.dart';
import 'package:global_chat/chat/data/repository/chat_repository_impl.dart';
import 'package:global_chat/chat/domain/repository/chat_repository.dart';
import 'package:global_chat/chat/domain/use_cases/do_delete_all_messages_use_case.dart';
import 'package:global_chat/chat/domain/use_cases/do_send_message_use_case.dart';
import 'package:global_chat/chat/domain/use_cases/get_all_Messages_use_case.dart';

Future<void> injectChatModule(GetIt getIt) async {
  // data source
  getIt.registerSingleton(ChatDataSource(firestore: getIt()));

  // repository
  getIt.registerSingleton<ChatRepository>(
      ChatRepositoryImpl(remote: getIt(), userRepository: getIt()));

  // use case
  getIt.registerSingleton(GetAllMessagesUseCase(repository: getIt()));
  getIt.registerSingleton(DoSendMessageUseCase(repository: getIt()));
  getIt.registerSingleton(DoDeleteAllMessagesUseCase(repository: getIt()));
}
