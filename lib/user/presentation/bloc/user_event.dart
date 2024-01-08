
part of 'user_bloc.dart';

sealed class UserEvent {
  const UserEvent();
}

final class SignInRequested extends UserEvent {
  Credential? userCredential;
  SignInRequested({this.userCredential});
}
final class SignOutRequested extends UserEvent {}
final class GetCurrentUser extends UserEvent {}
final class SignUpRequested extends UserEvent {
  Credential userCredential;
  SignUpRequested({ required this.userCredential});
}
final class DeleteAccountRequested extends UserEvent {
  Credential? userCredential;
  DeleteAccountRequested({this.userCredential});
}
