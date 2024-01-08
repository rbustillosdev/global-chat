part of 'user_bloc.dart';

class UserState {
  final User? currentUser;
  final UserStatus userStatus;
  final String? message;

  const UserState.initialState() : this();

  const UserState(
      {this.currentUser, this.userStatus = UserStatus.unauthenticated, this.message});

  UserState copyWith({User? currentUser, UserStatus? userStatus, String? message}) {
    return UserState(
        currentUser: currentUser,
        userStatus: userStatus ?? this.userStatus,
        message: message
    );
  }
}

enum UserStatus { authenticated, unauthenticated, error, loading, accountDeleted }
