import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';

import '../fastter/fastter.dart';
import '../models/user.model.dart';
import 'projects.dart';
import 'state.dart';
import 'todos.dart';

class ConfirmUserAction {
  ConfirmUserAction(this.bearer);

  final String bearer;
}

class LoginUserSuccessfull {
  LoginUserSuccessfull(this.user, this.bearer);

  final User user;
  final String bearer;
}

class LoginUserError {
  LoginUserError(this.errorMessage);

  final String errorMessage;
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
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is ConfirmUserAction) {
      Fastter.instance.bearer = action.bearer;
      try {
        Fastter.instance.checkCurrent().then((response) {
          if (response != null && response.current != null) {
            store.dispatch(
                LoginUserSuccessfull(response.current, action.bearer));
          } else {
            store.dispatch(LoginUserError('Invalid User'));
          }
        }).catchError((dynamic error) {
          store.dispatch(LoginUserError(error.toString()));
        });
      } catch (error) {
        store.dispatch(LoginUserError(error.toString()));
      }
    } else if (action is LoginUserSuccessfull) {
      Fastter.instance.bearer = action.bearer;
      Fastter.instance.user = action.user;

      fastterProjects.queries.initSubscriptions(store);
      fastterTodos.queries.initSubscriptions(store);
    } else if (action is LogoutUserAction || action is LoginUserError) {
      store.dispatch(ClearAll());
      Fastter.instance.logout();
      final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      _googleSignIn.signOut();
    } else if (action is LoginUserAction) {
      try {
        Fastter.instance.login(action.email, action.password).then((response) {
          if (response != null &&
              response.login != null &&
              response.login.user != null) {
            store.dispatch(LoginUserSuccessfull(
                response.login.user, response.login.bearer));
          } else {
            store.dispatch(LoginUserError('Wrong username password'));
          }
        }).catchError((dynamic error) {
          store.dispatch(LoginUserError(error.toString()));
        });
      } catch (error) {
        store.dispatch(LoginUserError(error.toString()));
      }
    } else if (action is GoogleLoginUserAction) {
      try {
        Fastter.instance
            .request(
          Request(
            query: '''
            mutation(\$idToken: String!) {
              login:loginWithGoogle(input:{idToken:\$idToken}) {bearer, user {...user}}
            }
            $userFragment
            ''',
            variables: <String, dynamic>{
              'idToken': action.idToken,
            },
          ),
        )
            .then((resp) {
          final response = LoginData.fromJson(resp);
          if (response != null &&
              response.login != null &&
              response.login.user != null) {
            store.dispatch(LoginUserSuccessfull(
                response.login.user, response.login.bearer));
          } else {
            store.dispatch(LoginUserError('Wrong username password'));
          }
        }).catchError((dynamic error) {
          store.dispatch(LoginUserError(error.toString()));
        });
      } catch (error) {
        store.dispatch(LoginUserError(error.toString()));
      }
    }
    next(action);
  }
}
