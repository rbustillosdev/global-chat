import 'package:get_it/get_it.dart';
import 'package:global_chat/user/domain/use_cases/do_delete_account_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_in_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_out_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_up_use_case.dart';
import 'package:global_chat/user/domain/use_cases/get_current_user_use_case.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc.dart';


UserBloc userBlocConstructor() => UserBloc(
    doSignInUseCase: GetIt.instance<DoSignInUseCase>(),
    doSignUpUseCase: GetIt.instance<DoSignUpUseCase>(),
    doSignOutUseCase: GetIt.instance<DoSignOutUseCase>(),
    doDeleteAccountUseCase: GetIt.instance<DoDeleteAccountUseCase>(),
    getCurrentUserUseCase: GetIt.instance<GetCurrentUserUseCase>());