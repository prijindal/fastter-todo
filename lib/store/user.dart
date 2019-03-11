import 'package:redux/redux.dart';
import '../models/user.model.dart';
import 'state.dart';
import '../fastter/fastter.dart';

class ConfirmUserAction {
  final String bearer;
  ConfirmUserAction(this.bearer);
}

class LoginUserSuccessfull {
  final User user;
  final String bearer;
  LoginUserSuccessfull(this.user, this.bearer);
}

class LoginUserError {
  final String errorMessage;
  LoginUserError(this.errorMessage);
}

class GoogleLoginUserAction {
  GoogleLoginUserAction(this.idToken);

  final String idToken;
}

class LoginUserAction {
  LoginUserAction(this.email, this.password);

  final String email;
  final String password;
}

class LogoutUserAction {}

UserState userReducer(UserState state, dynamic action) {
  if (action is LoginUserAction) {
    return UserState(
      user: null,
      bearer: null,
      isLoading: true,
      errorMessage: null,
    );
  } else if (action is GoogleLoginUserAction) {
    return UserState(
      bearer: null,
      user: null,
      isLoading: true,
      errorMessage: null,
    );
  } else if (action is ConfirmUserAction) {
    return UserState(
      user: state.user,
      bearer: action.bearer,
      isLoading: true,
      errorMessage: null,
    );
  } else if (action is LogoutUserAction) {
    return UserState(
      user: null,
      bearer: null,
      isLoading: false,
      errorMessage: null,
    );
  } else if (action is LoginUserError) {
    return UserState(
        user: null,
        bearer: null,
        isLoading: false,
        errorMessage: action.errorMessage);
  } else if (action is LoginUserSuccessfull) {
    return UserState(
      user: action.user,
      bearer: action.bearer,
      isLoading: false,
      errorMessage: null,
    );
  } else {
    return state;
  }
}

class UserMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is ConfirmUserAction) {
      fastter.bearer = action.bearer;
      try {
        fastter
            .request(new Request(
          query: '{current {...user}} $userFragment',
        ))
            .then((resp) {
          CurrentData response = CurrentData.fromJson(resp);
          if (response != null && response.current != null) {
            store.dispatch(
                LoginUserSuccessfull(response.current, action.bearer));
          } else {
            store.dispatch(LoginUserError('Invalid User'));
          }
        });
      } catch (error) {
        store.dispatch(LoginUserError(error.toString()));
      }
    } else if (action is LoginUserSuccessfull) {
      fastter.bearer = action.bearer;
      fastter.user = action.user;
    } else if (action is LogoutUserAction || action is LoginUserError) {
      fastter.bearer = null;
      fastter.user = null;
    } else if (action is LoginUserAction) {
      try {
        fastter.login(action.email, action.password).then((response) {
          if (response != null && response.login != null) {
            if (response != null &&
                response.login != null &&
                response.login.user != null) {
              store.dispatch(LoginUserSuccessfull(
                  response.login.user, response.login.bearer));
            } else {
              store.dispatch(LoginUserError('Wrong username password'));
            }
          }
        });
      } catch (error) {
        store.dispatch(LoginUserError(error.toString()));
      }
    } else if (action is GoogleLoginUserAction) {
      try {
        fastter
            .request(
          new Request(
            query:
                "mutation(\$idToken: String!) {login:loginWithGoogle(input:{idToken:\$idToken}) {bearer, user {...user}}} $userFragment",
            variables: {
              'idToken': action.idToken,
            },
          ),
        )
            .then((resp) {
          LoginData response = LoginData.fromJson(resp);
          if (response != null && response.login != null) {
            if (response != null &&
                response.login != null &&
                response.login.user != null) {
              store.dispatch(LoginUserSuccessfull(
                  response.login.user, response.login.bearer));
            } else {
              store.dispatch(LoginUserError('Wrong username password'));
            }
          }
        });
      } catch (error) {
        store.dispatch(LoginUserError(error.toString()));
      }
    }
    next(action);
  }
}
