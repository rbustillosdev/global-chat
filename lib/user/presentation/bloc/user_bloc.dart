import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/domain/use_cases/do_delete_account_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_in_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_out_use_case.dart';
import 'package:global_chat/user/domain/use_cases/do_sign_up_use_case.dart';
import 'package:global_chat/user/domain/use_cases/get_current_user_use_case.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DoSignInUseCase doSignInUseCase;
  final DoSignUpUseCase doSignUpUseCase;
  final DoSignOutUseCase doSignOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final DoDeleteAccountUseCase doDeleteAccountUseCase;

  UserBloc(
      {required this.doSignInUseCase,
      required this.doSignUpUseCase,
      required this.doSignOutUseCase,
      required this.getCurrentUserUseCase,
      required this.doDeleteAccountUseCase})
      : super(const UserState.initialState()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<GetCurrentUser>(_onGetAuthenticatedUser);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<UserState> emitter) async {
    emitter(state.copyWith(userStatus: UserStatus.loading));
    try {
      final User user;
      if (event.userCredential == null) {
        user = await doSignInUseCase();
      } else {
        user = await doSignInUseCase.callWithCredential(event.userCredential!);
      }
      emitter(state.copyWith(
          currentUser: user, userStatus: UserStatus.authenticated));
    } catch (e) {
      String code = "unknown-error";
      if (e is FirebaseAuthException) {
        code = e.code;
      }
      emitter(state.copyWith(
          userStatus: UserStatus.error, message: messageByCode[code]));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<UserState> emitter) async {
    emitter(state.copyWith(userStatus: UserStatus.loading));
    try {
      final User user = await doSignUpUseCase(event.userCredential);
      emitter(state.copyWith(
          currentUser: user, userStatus: UserStatus.authenticated));
    } catch (e) {
      String code = "unknown-error";
      if (e is FirebaseAuthException) {
        code = e.code;
      }
      emitter(state.copyWith(
          userStatus: UserStatus.error, message: messageByCode[code]));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<UserState> emitter) async {
    emitter(state.copyWith(userStatus: UserStatus.loading));
    try {
      await doSignOutUseCase();
      emitter(state.copyWith(
          currentUser: null, userStatus: UserStatus.unauthenticated));
    } catch (e) {
      emitter(state.copyWith(userStatus: UserStatus.error));
    }
  }

  Future<void> _onGetAuthenticatedUser(
      GetCurrentUser event, Emitter<UserState> emitter) async {
    final user = getCurrentUserUseCase();
    emitter(state.copyWith(
        currentUser: user,
        userStatus: user != null
            ? UserStatus.authenticated
            : UserStatus.unauthenticated));
  }

  Future<void> _onDeleteAccountRequested(
      DeleteAccountRequested event, Emitter<UserState> emitter) async {
    emitter(state.copyWith(userStatus: UserStatus.loading));
    try {
      await doDeleteAccountUseCase(event.userCredential);
      emitter(state.copyWith(userStatus: UserStatus.accountDeleted));
    } catch (e) {
      String code = "unknown-error";
      if (e is FirebaseAuthException) {
        code = e.code;
        if (code == 'invalid-credential') {
          code = 'invalid-password';
        }
      }
      emitter(state.copyWith(
          userStatus: UserStatus.error, message: messageByCode[code]));
    }
  }

  static const Map<String, String> messageByCode = {
    'invalid-credential':
        'Oops, looks like someone has the wrong email or password.',
    'invalid-password': 'Wrong password, try it again with the correct password.',
    'weak-password': 'That password should be stronger.',
    'email-already-exists':
        'Looks like you\'ve already signed up with this email',
    'unknown-error': 'Something went wrong... try it again.'
  };
}
