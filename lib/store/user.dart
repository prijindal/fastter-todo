import 'dart:async';
import 'package:bloc/bloc.dart';

import '../models/settings.model.dart';
import '../models/user.model.dart';

abstract class UserEvent {}

class InitStateUserEvent extends UserEvent {
  InitStateUserEvent(this.initState);

  final UserState initState;
}

class ConfirmUserEvent extends UserEvent {
  ConfirmUserEvent(this.bearer) : completer = Completer<void>();

  final String? bearer;
  final Completer<void> completer;
}

class LoginUserError extends UserEvent {
  LoginUserError(this.errorMessage);

  final String errorMessage;
}

class LoginUserSuccessfull extends UserEvent {
  LoginUserSuccessfull(this.user, this.bearer);

  final User user;
  final String bearer;
}

class GoogleLoginUserEvent extends UserEvent {
  GoogleLoginUserEvent(this.idToken);

  final String idToken;
}

class LoginUserEvent extends UserEvent {
  LoginUserEvent(this.email, this.password);

  final String email;
  final String password;
}

class SignupUserEvent extends UserEvent {
  SignupUserEvent(this.email, this.password);

  final String email;
  final String password;
}

class UpdateUserEvent extends UserEvent {
  UpdateUserEvent({this.name, this.email, this.picture, this.settings})
      : completer = Completer<void>();

  final Completer<void> completer;
  final String? name;
  final String? email;
  final String? picture;
  final UserSettings? settings;
}

class UpdateUserPasswordEvent extends UserEvent {
  UpdateUserPasswordEvent(this.password) : completer = Completer<void>();

  final Completer<void> completer;
  final String password;
}

class LogoutUserEvent extends UserEvent {}

class DeleteUserEvent extends UserEvent {}

class ClearAll extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({this.initMessaging, this.onLogout})
      : super(UserState(
          bearer: null,
          user: null,
        )) {
    on((UserEvent event, emit) async {
      if (event is InitStateUserEvent) {
        emit(event.initState);
      } else if (event is ConfirmUserEvent) {
        emit(UserState(
          user: state.user,
          bearer: event.bearer,
          initLoaded: false,
          isLoading: true,
          errorMessage: null,
        ));
        // await _confirmUser(event);
      } else if (event is GoogleLoginUserEvent) {
        emit(UserState(
          bearer: null,
          initLoaded: true,
          user: null,
          isLoading: true,
          errorMessage: null,
        ));
        // await _googleLogin(event);
      } else if (event is LoginUserEvent) {
        emit(UserState(
          user: null,
          bearer: null,
          isLoading: true,
          errorMessage: null,
          initLoaded: true,
        ));
        add(
          LoginUserSuccessfull(
            User(
                name: "Priyanshu Jindal",
                email: "priyanshujindal1995@gmail.com"),
            '',
          ),
        );
        // await _loginUser(event);
      } else if (event is SignupUserEvent) {
        emit(UserState(
          user: null,
          bearer: null,
          isLoading: true,
          errorMessage: null,
          initLoaded: true,
        ));
        // await _signupUser(event);
      } else if (event is UpdateUserEvent) {
        emit(UserState(
          user: User(
            id: state.user?.id,
            picture:
                event.picture != null ? event.picture : state.user?.picture,
            name: event.name != null ? event.name : state.user?.name,
            email: event.email != null ? event.email : state.user?.email,
            settings:
                event.settings != null ? event.settings : state.user?.settings,
          ),
          initLoaded: true,
          bearer: state.bearer,
          isLoading: false,
          errorMessage: null,
        ));
        // await _updateUser(event);
      } else if (event is UpdateUserPasswordEvent) {
        // await _updatePassword(event);
      } else if (event is LogoutUserEvent) {
        emit(UserState(
          user: null,
          bearer: null,
          initLoaded: true,
          isLoading: false,
          errorMessage: null,
        ));
        add(ClearAll());
        // Fastter.instance.logout();
        if (onLogout != null) {
          onLogout!();
        }
      } else if (event is DeleteUserEvent) {
        emit(UserState(
          user: null,
          bearer: null,
          initLoaded: true,
          isLoading: false,
          errorMessage: null,
        ));
        // await _deleteUser(event);
      } else if (event is LoginUserSuccessfull) {
        emit(UserState(
          user: event.user,
          initLoaded: true,
          bearer: event.bearer,
          isLoading: false,
          errorMessage: null,
        ));
        // _initMessaging();
      } else if (event is LoginUserError) {
        add(ClearAll());
        // Fastter.instance.logout();
        if (onLogout != null) {
          onLogout!();
        }
      } else if (event is ClearAll) {
        emit(UserState(
          bearer: null,
          user: null,
        ));
      }
    });
  }

  final Future<String> Function()? initMessaging;
  final void Function()? onLogout;
}
