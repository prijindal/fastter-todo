import '../models/user.model.dart';

class LoginUserAction {
  LoginUserAction(this.user);

  User user;
}

class LogoutUserAction {}

User userReducer(User state, dynamic action) {
  if (action is LogoutUserAction || state == null) {
    return User();
  } else if (action is LoginUserAction) {
    return action.user;
  } else {
    return state;
  }
}
