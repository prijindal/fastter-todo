import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_bus/event_bus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import '../models/user.model.dart';

class Response {
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

  String requestId;
  Map<String, dynamic> data;
  List<dynamic> errors;
}

class Request {
  Request({
    this.query,
    this.variables,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        query: json['query'],
        variables: json['variables'],
      );

  String requestId;
  String jwtToken;
  String apiToken;
  String query;
  Map<String, dynamic> variables;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'requestId': requestId,
        'jwtToken': jwtToken,
        'apiToken': apiToken,
        'query': query,
        'variables': variables,
      };
}

class RequestStreamEvent {
  RequestStreamEvent(this.request, this.completer);

  final Request request;
  final Completer completer;
}

class Fastter {
  Fastter(
    this.url,
    this.apiToken, {
    String type = 'socket',
    this.onStarted,
    this.onCompleted,
  }) {
    requests = {};
    subscriptions = {};
    if (type == 'socket') {
      socket = IO.io(url, <dynamic, dynamic>{
        'forceNew': true,
        'transports': ['websocket']
      });
    }
    _initListeners();
  }

  static Fastter _instance;

  static Fastter get instance => getInstance();

  static Fastter getInstance() {
    if (_instance == null) {
      const API_TOKEN = 'MlwjS+Qwco5Sd2qq+4oU7LKBCyUh2aaTbow7SrKW/GI=';
      const URL = 'https://apifastter.easycode.club';

      _instance = Fastter(URL, API_TOKEN);
    }
    return _instance;
  }

  final String url;
  void Function(Request request) onStarted;
  void Function(Request request, Response response) onCompleted;
  IO.Socket socket;
  Map<String, EventBus> requests;
  Map<String, EventBus> subscriptions;

  String apiToken;

  String bearer;
  User user;

  final Uuid _uuidGenerator = Uuid();

  void _initListeners() {
    if (socket != null) {
      socket.on('connect', (dynamic _) {
        print('connected');
      });
      socket.on('graphqlResponse', (dynamic response) {
        if (response != null) {
          final resp = Response.fromJson(response);
          if (requests.containsKey(resp.requestId)) {
            requests[resp.requestId].fire(resp);
          }
        }
      });
      socket.on('graphqlSubscriptionResponse', (dynamic response) {
        if (response != null && response is Map<String, dynamic>) {
          for (final key in response.keys) {
            if (subscriptions.containsKey(key)) {
              subscriptions[key].fire(response[key]);
            }
          }
        }
      });
      socket.on('disconnect', (dynamic _) => print('disconnect'));
    }
  }

  void connect() {
    socket.connect();
  }

  Future<Map<String, dynamic>> request(Request data) {
    final completer = Completer<Map<String, dynamic>>();
    final String requestId = _uuidGenerator.v1();
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
    final ee = EventBus(sync: true);
    ee.on<Response>().listen((resp) {
      // response.data = (response.type).fromJson(resp['data']);
      if (resp.errors != null && resp.errors.isNotEmpty) {
        if (!completer.isCompleted) {
          completer.completeError(resp.errors[0]['message']);
        }
      } else if (resp.data != null) {
        if (!completer.isCompleted) {
          completer.complete(resp.data);
        }
        if (onCompleted != null) {
          onCompleted(data, resp);
        }
      } else {
        throw Exception(resp);
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
    requests[data.requestId] = ee;
    try {
      socket.emit('graphql', data.toJson());
    } catch (error) {
      throw Exception(error);
    }
  }

  void _requestHttp(Request data, EventBus ee) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    headers['Authorization'] = data.jwtToken;
    headers['API_TOKEN'] = data.apiToken;
    http
        .post(
      '$url/graphql',
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
    subscriptions[field] = ee;
    return ee;
  }

  Future<CurrentData> checkCurrent() async {
    if (bearer != null && bearer.isNotEmpty) {
      return request(
        Request(
          query: '''
              {current {...user}} $userFragment
            ''',
        ),
      ).then((resp) {
        final response = CurrentData.fromJson(resp);
        if (response != null && response.current != null) {
          user = response.current;
        }
        return response;
      });
    } else {
      return null;
    }
  }

  Future<LoginData> login(String email, String password) => request(
        Request(
          query: '''
          mutation(\$email:String!,\$password:String!) {
            login(input: {email: \$email, password:\$password}) {
              bearer
              user { ...user }
            }
          } $userFragment''',
          variables: <String, dynamic>{
            'email': email,
            'password': password,
          },
        ),
      ).then((dynamic data) {
        final loginData = LoginData.fromJson(data);
        if (loginData != null && loginData.login != null) {
          bearer = loginData.login.bearer;
        }
        return loginData;
      });

  Future<dynamic> logout() async {
    if (bearer != null && bearer.isNotEmpty) {
      return request(
        Request(
          query: '''
          mutation {
            logout {
              status
            }
          }''',
          variables: <String, dynamic>{},
        ),
      ).then<dynamic>((data) {
        bearer = null;
        user = null;
        for (final ee in requests.values) {
          ee.destroy();
        }
        requests = {};
        for (final ee in subscriptions.values) {
          ee.destroy();
        }
        subscriptions = {};
        return data;
      });
    } else {
      return null;
    }
  }
}
