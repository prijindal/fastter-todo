String bearerReducer(String state, dynamic action) {
  if (action is InitAuthAction) {
    return action.bearer;
  } else if (action is ClearAuthAction) {
    return null;
  }
  return state;
}

class InitAuthAction {
  InitAuthAction(this.bearer);

  String bearer;
}

class ClearAuthAction {}
