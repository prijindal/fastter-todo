import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_bus/event_bus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import '../models/user.model.dart';

class Response {
  String requestId;
  Map<String, dynamic> data;
  List<dynamic> errors;

  Response({
    this.errors,
    this.data,
    this.requestId,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        errors: json['errors'],
        data: json['data'],
        requestId: json['requestId'],
      );
}

class Request {
  Request({
    this.query,
    this.variables,
  });

  String requestId;
  String jwtToken;
  String apiToken;
  String query;
  Map<String, dynamic> variables;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        query: json['query'],
        variables: json['variables'],
      );

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'jwtToken': jwtToken,
        'apiToken': apiToken,
        'query': query,
        'variables': variables,
      };
}

class RequestStreamEvent {
  final Request request;
  final Completer completer;
  RequestStreamEvent(this.request, this.completer);
}

class Fastter {
  final String url;
  void Function(Request request) onStarted;
  void Function(Request request, Response response) onCompleted;
  IO.Socket socket;
  Map<String, EventBus> requests;
  Map<String, EventBus> subscriptions;

  String apiToken;

  String bearer;
  User user;

  Fastter(
    this.url,
    String apiToken, {
    String type = "socket",
    this.onStarted,
    this.onCompleted,
  }) {
    requests = {};
    subscriptions = {};
    this.apiToken = apiToken;
    if (type == "socket") {
      socket = IO.io(url, <dynamic, dynamic>{
        'forceNew': true,
        'transports': ['websocket']
      });
    }
    _initListeners();
  }

  _initListeners() {
    if (socket != null) {
      socket.on('connect', (_) {
        print('connected');
      });
      socket.on('graphqlResponse', (dynamic response) {
        if (response != null) {
          Response resp = Response.fromJson(response);
          if (this.requests.containsKey(resp.requestId)) {
            this.requests[resp.requestId].fire(resp);
          }
        }
      });
      socket.on('graphqlSubscriptionResponse', (dynamic response) {
        if (response != null) {
          response.keys.forEach((key) {
            if (this.subscriptions.containsKey(key)) {
              this.subscriptions[key].fire(response[key]);
            }
          });
        }
      });
      socket.on('disconnect', (_) => print('disconnect'));
    }
  }

  connect() {
    socket.connect();
  }

  Future<Map<String, dynamic>> request(Request data) {
    var completer = new Completer<Map<String, dynamic>>();
    Uuid uuidGenerator = new Uuid();
    String requestId = uuidGenerator.v1();
    data.requestId = requestId;
    if (bearer != null) {
      data.jwtToken = bearer;
    }
    if (apiToken != null) {
      data.apiToken = apiToken;
    }
    if (onStarted != null) {
      onStarted(data);
    }
    EventBus ee = new EventBus(sync: true);
    ee.on<Response>().listen((Response resp) {
      // response.data = (response.type).fromJson(resp['data']);
      if (resp.errors != null && resp.errors.length > 0) {
        throw new FastterError(resp.errors[0]);
      } else if (resp.data != null) {
        // resolve(response)
        completer.complete(resp.data);
        if (onCompleted != null) {
          onCompleted(data, resp);
        }
      } else {
        throw new FastterError(resp);
      }
    });
    if (socket != null) {
      _requestSocket(data, ee);
    } else {
      _requestHttp(data, ee);
    }
    return completer.future;
  }

  void _requestSocket(Request data, EventBus ee) {
    this.requests[data.requestId] = ee;
    try {
      socket.emit('graphql', data.toJson());
    } catch (error) {
      throw FastterError(error);
    }
  }

  void _requestHttp(Request data, EventBus ee) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    headers['Authorization'] = data.jwtToken;
    headers['API_TOKEN'] = data.apiToken;
    http
        .post(
      url + "/graphql",
      body: json.encode(
        data.toJson(),
        toEncodable: (dynamic item) {
          if (item is DateTime) {
            return item.toIso8601String();
          }
          return item;
        },
      ),
      headers: headers,
    )
        .then((response) {
      ee.fire(Response.fromJson(json.decode(response.body)));
    });
  }

  EventBus addSubscription(String field) {
    final ee = EventBus();
    this.subscriptions[field] = ee;
    return ee;
  }

  Future<LoginData> login(String email, String password) {
    return request(
      new Request(
        query: '''
          mutation(\$email:String!,\$password:String!) {
            login(input: {email: \$email, password:\$password}) {
              bearer
              user { ...user }
            }
          } $userFragment''',
        variables: {
          'email': email,
          'password': password,
        },
      ),
    ).then((dynamic data) {
      LoginData loginData = LoginData.fromJson(data);
      if (loginData != null && loginData.login != null) {
        bearer = loginData.login.bearer;
      }
      return loginData;
    });
  }

  Future<dynamic> logout(String email, String password) {
    return request(
      new Request(
        query: '''
          mutation {
            logout {
              status
            }
          }''',
        variables: {},
      ),
    ).then((data) {
      bearer = null;
      return data;
    });
  }
}

class FastterError {
  FastterError(this.error);

  final dynamic error;

  @override
  String toString() {
    return error.toString();
  }
}

const API_TOKEN = "MlwjS+Qwco5Sd2qq+4oU7LKBCyUh2aaTbow7SrKW/GI=";
const URL = "https://apifastter.easycode.club";

Fastter fastter = new Fastter(URL, API_TOKEN);
