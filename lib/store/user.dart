import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';

import '../fastter/fastter.dart';
import '../models/user.model.dart';
import '../helpers/firebase.dart' show initMessaging;
import 'projects.dart';
import 'state.dart';
import 'todocomments.dart';
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

class UpdateUserAction {
  UpdateUserAction({this.name, this.email, this.picture})
      : completer = Completer<void>();

  final Completer<void> completer;
  final String name;
  final String email;
  final String picture;
}

class UpdateUserPasswordAction {
  UpdateUserPasswordAction(this.password) : completer = Completer<void>();

  final Completer<void> completer;
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
      initLoaded: true,
    );
  } else if (action is GoogleLoginUserAction) {
    return UserState(
      bearer: null,
      initLoaded: true,
      user: null,
      isLoading: true,
      errorMessage: null,
    );
  } else if (action is ConfirmUserAction) {
    return UserState(
      user: state.user,
      bearer: action.bearer,
      initLoaded: false,
      isLoading: true,
      errorMessage: null,
    );
  } else if (action is LogoutUserAction) {
    return UserState(
      user: null,
      bearer: null,
      initLoaded: true,
      isLoading: false,
      errorMessage: null,
    );
  } else if (action is LoginUserError) {
    return UserState(
        user: null,
        bearer: null,
        isLoading: false,
        initLoaded: true,
        errorMessage: action.errorMessage);
  } else if (action is LoginUserSuccessfull) {
    return UserState(
      user: action.user,
      initLoaded: true,
      bearer: action.bearer,
      isLoading: false,
      errorMessage: null,
    );
  } else if (action is UpdateUserAction) {
    return UserState(
      user: User(
        id: state.user.id,
        picture: action.picture != null ? action.picture : state.user.picture,
        name: action.name != null ? action.name : state.user.name,
        email: action.email != null ? action.email : state.user.email,
      ),
      initLoaded: true,
      bearer: state.bearer,
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
      _confirmUser(store, action);
    } else if (action is LoginUserSuccessfull) {
      Fastter.instance.bearer = action.bearer;
      Fastter.instance.user = action.user;

      fastterProjects.queries.initSubscriptions(store);
      fastterTodos.queries.initSubscriptions(store);
      fastterTodoComments.queries.initSubscriptions(store);
    } else if (action is LogoutUserAction || action is LoginUserError) {
      store.dispatch(ClearAll());
      Fastter.instance.logout();
      final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      _googleSignIn.signOut();
    } else if (action is LoginUserAction) {
      _loginUser(store, action);
    } else if (action is GoogleLoginUserAction) {
      _googleLogin(store, action);
    } else if (action is UpdateUserAction) {
      _updateUser(store, action);
    } else if (action is UpdateUserPasswordAction) {
      _updatePassword(store, action);
    }
    next(action);
  }

  Future<void> _confirmUser(
      Store<AppState> store, ConfirmUserAction action) async {
    Fastter.instance.bearer = action.bearer;
    try {
      final response = await Fastter.instance.checkCurrent();
      if (response != null && response.current != null) {
        store.dispatch(LoginUserSuccessfull(response.current, action.bearer));
        initMessaging();
      } else {
        throw new Exception('Invalid User');
      }
    } catch (error) {
      store.dispatch(LoginUserError(error.toString()));
    }
  }

  Future<void> _loginUser(Store<AppState> store, LoginUserAction action) async {
    try {
      final response =
          await Fastter.instance.login(action.email, action.password);
      if (response.login.user != null) {
        store.dispatch(
          LoginUserSuccessfull(response.login.user, response.login.bearer),
        );
        initMessaging();
      } else {
        throw Exception('Wrong username password');
      }
    } catch (error) {
      store.dispatch(LoginUserError(error.toString()));
    }
  }

  Future<void> _googleLogin(
      Store<AppState> store, GoogleLoginUserAction action) async {
    try {
      final resp = await Fastter.instance.request(
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
      );

      final response = LoginData.fromJson(resp);
      if (response.login.user != null) {
        store.dispatch(
            LoginUserSuccessfull(response.login.user, response.login.bearer));
      } else {
        throw Exception('Wrong username password');
      }
    } catch (error) {
      store.dispatch(LoginUserError(error.toString()));
    }
  }

  Future<void> _updateUser(
      Store<AppState> store, UpdateUserAction action) async {
    try {
      await Fastter.instance.request(
        Request(
          query: '''
              mutation(\$email:String, \$name:String, \$picture: String) {
                updateUser(input:{email:\$email,name:\$name, picture: \$picture}) {
                  ...user
                }
              }
              $userFragment
            ''',
          variables: {
            'name': action.name,
            'email': action.email,
            'picture': action.picture,
          },
        ),
      );
      action.completer.complete();
    } catch (error) {
      store.dispatch(LoginUserError(error.toString()));
    }
  }

  Future<void> _updatePassword(
      Store<AppState> store, UpdateUserPasswordAction action) async {
    try {
      await Fastter.instance.request(
        Request(
          query: '''
              mutation(\$password:String) {
                updatePassword(input:{password:\$password}) {
                  ...user
                }
              }
              $userFragment
            ''',
          variables: {
            'password': action.password,
          },
        ),
      );
    } catch (error) {
      store.dispatch(LoginUserError(error.toString()));
    }
  }
}
