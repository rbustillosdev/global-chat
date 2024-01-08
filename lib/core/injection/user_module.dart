import 'package:get_it/get_it.dart';
import 'package:global_chat/user/data/remote/user_data_source.dart';
import 'package:global_chat/user/data/repository/user_repository_impl.dart';
import 'package:global_chat/user/domain/repository/user_repository.dart';
import 'package:global_chat/user/domain/use_cases/do_delete_account_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_in_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_out_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_up_use_case.dart';
import 'package:global_chat/user/domain/use_cases/get_current_user_use_case.dart';

Future<void> injectUserModule(GetIt getIt) async {
  // data source
  getIt.registerSingleton(UserDataSource(firebaseAuth: getIt()));

  // repository
  getIt.registerSingleton<UserRepository>(
      UserRepositoryImpl(firebaseAuth: getIt(), remote: getIt()));

  // use case
  getIt.registerSingleton(DoSignInUseCase(repository: getIt()));
  getIt.registerSingleton(DoSignUpUseCase(repository: getIt()));
  getIt.registerSingleton(DoSignOutUseCase(repository: getIt()));
  getIt.registerSingleton(GetCurrentUserUseCase(repository: getIt()));
  getIt.registerSingleton(DoDeleteAccountUseCase(repository: getIt()));
}
