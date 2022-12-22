import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:event_bus/event_bus.dart';
import 'package:uuid/uuid.dart';
import 'package:bloc/bloc.dart';
import '../models/user.model.dart';

class Response {
  Response({
    required this.errors,
    required this.data,
    required this.requestId,
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
    required this.query,
    this.variables = const <String, dynamic>{},
  }) : requestId = const Uuid().v4();

  String requestId;
  String query;
  Map<String, dynamic> variables;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'requestId': requestId,
        'query': query.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' '),
        'variables': variables,
      };
}

class SingleRequest extends Request {
  SingleRequest({
    required String query,
    Map<String, dynamic> variables = const <String, dynamic>{},
    this.skipResponse = false,
  }) : super(query: query, variables: variables);

  bool skipResponse;

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll(<String, dynamic>{
      'skipResponse': skipResponse,
    });
    return map;
  }
}

class MultipleRequest {
  MultipleRequest({this.queries = const <Request>[]});

  List<Request> queries;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'queries': queries.map((query) => query.toJson()).toList(),
      };
}

enum FastterConnectEvent { connected, disconnected }

class Fastter extends Bloc<FastterConnectEvent, bool> {
  /// [type] can be "socket" or "http"
  Fastter(this.url, this.apiToken, this.accessKey, [String type = 'socket'])
      : super(false) {
    on((FastterConnectEvent event, emit) {
      if (event == FastterConnectEvent.connected) {
        emit(true);
      } else if (event == FastterConnectEvent.disconnected) {
        emit(false);
      }
    });
    requests = {};
    subscriptions = {};
    if (type == 'socket') {
      _tryConnect();
    } else {
      print(httpUrl);
      auth();
      _initListeners();
      add(FastterConnectEvent.connected);
    }
  }

  void _tryConnect() {
    WebSocket.connect(url, headers: <String, dynamic>{
      'User-Agent': userAgent,
    }).then((ws) {
      socket = ws;
      auth();
      _initListeners();
      if (onConnect != null) {
        onConnect!();
      }
      print('connected');
      add(FastterConnectEvent.connected);
    }).catchError((dynamic error) {
      add(FastterConnectEvent.disconnected);
      Timer(Duration(seconds: 5), _tryConnect);
    });
  }

  static Fastter? _instance;

  static Fastter get instance => getInstance();

  String get httpUrl {
    final uri = Uri.parse(url);
    if (uri.isScheme('wss')) {
      return url.replaceFirst('wss://', 'https://');
    } else {
      return url.replaceFirst('ws://', 'http://');
    }
  }

  static Fastter getInstance() {
    if (_instance == null) {
      const accessKey = 'vroszxouybesoabdxemvetsdgjvhhqbw';
      const apiToken = 'vUb/05hZ+qtVzG1b4gi5FF/kjh1PCW8QrlqYosVjIEA=';
      const url = 'wss://apifastter.easycode.club';
      // const apiToken = 'lmUTAQ5xSDNU52fozOBRHlKG57Pgw05dha2btzJQ1nE=';
      // const url = 'ws://localhost:4000';

      _instance = Fastter(url, apiToken, accessKey, 'http');
    }
    return _instance!;
  }

  late final String url;
  WebSocket? socket;
  late final Map<String, EventBus> requests;
  late Map<String, EventBus> subscriptions;
  late void Function() onConnect;

  String get userAgent {
    var ua = 'com.prijindal.fastter_todo;';
    ua += ' Dart ${Platform.version};';
    ua += ' ${Platform.operatingSystem};';
    ua += ' ${Platform.operatingSystemVersion};';
    return ua;
  }

  final String apiToken;
  final String accessKey;

  String? bearer;
  User? user;

  final Uuid _uuidGenerator = Uuid();

  bool get _isSocketConnected =>
      socket != null && socket?.readyState == WebSocket.open;

  void _initListeners() {
    if (!_isSocketConnected) {
      return;
    }
    socket?.listen(
      (dynamic message) {
        try {
          final Map<String, dynamic> msg = json.decode(message);
          if (msg['type'] == 'graphqlResponse') {
            final dynamic response = msg['data'];
            if (response != null) {
              final resp = Response.fromJson(response);
              if (requests.containsKey(resp.requestId)) {
                requests[resp.requestId]?.fire(resp);
              }
            }
          } else if (msg['type'] == 'graphqlSubscriptionResponse') {
            final dynamic response = msg['data'];
            if (response != null && response is Map<String, dynamic>) {
              for (final key in response.keys) {
                if (subscriptions.containsKey(key)) {
                  subscriptions[key]?.fire(response[key]);
                }
              }
            }
          }
        } on Exception catch (e) {
          print(e.toString());
        }
      },
      onDone: _onDisconnected,
      onError: (dynamic error) => _onDisconnected(),
    );
    socket?.done.then((dynamic _) => _onDisconnected());
  }

  void _onDisconnected() {
    print('Disconnected');
    if (socket != null) {
      socket?.close();
    }
    socket = null;
    add(FastterConnectEvent.disconnected);
    _tryConnect();
  }

  void connect() {
    // socket.connect();
  }

  void auth() {
    final message = <String, dynamic>{
      'type': 'auth',
      'data': {
        'apiToken': apiToken,
        'jwtToken': bearer,
        'x-access-key': accessKey,
      },
    };
    if (_isSocketConnected) {
      socket?.add(json.encode(message));
    }
  }

  Future<Map<String, dynamic>> request(SingleRequest data) {
    final ee = EventBus(sync: true);
    final completer = Completer<Map<String, dynamic>>();
    if (data.skipResponse != true) {
      final requestId = _uuidGenerator.v1();
      data.requestId = requestId;
      _listenResponse(requestId, ee, completer);
    } else {
      completer.complete();
    }
    if (_isSocketConnected) {
      final message = <String, dynamic>{
        'type': 'graphql',
        'data': data.toJson(),
      };
      socket?.add(json.encode(message));
    } else {
      _sendHttpRequest(
        '/graphql',
        json.encode(data.toJson()),
        (dynamic data) => completer.complete(data),
      );
    }
    return completer.future;
  }

  void _sendHttpRequest(
      String path, String body, void Function(dynamic body) resolve) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (bearer != null) {
      headers['authorization'] = bearer!;
    }
    if (apiToken != null) {
      headers['x-api-token'] = apiToken;
    }
    if (accessKey != null) {
      headers['x-access-key'] = accessKey;
    }
    if (userAgent != null) {
      headers['User-Agent'] = userAgent;
    }
    final request = http.post(
      Uri.parse(httpUrl + path),
      headers: headers,
      body: body,
    );
    request.then((response) async {
      try {
        final dynamic jsonResponse = json.decode(response.body);
        resolve(jsonResponse['data']);
      } on Exception {
        resolve(null);
      }
    });
  }

  void _listenResponse(String requestId, EventBus ee,
      Completer<Map<String, dynamic>> completer) {
    ee.on<Response>().listen((resp) {
      // response.data = (response.type).fromJson(resp['data']);
      if (requests.containsKey(resp.requestId)) {
        requests.remove(resp.requestId);
      }
      if (resp.errors != null && resp.errors.isNotEmpty) {
        if (!completer.isCompleted) {
          completer.completeError(resp.errors[0]['message']);
        }
      } else if (resp.data != null) {
        if (!completer.isCompleted) {
          completer.complete(resp.data);
        }
      } else {
        throw Exception(resp);
      }
    });
    requests[requestId] = ee;
  }

  void multipleRequest(MultipleRequest data) {
    if (_isSocketConnected) {
      final message = <String, dynamic>{
        'type': 'graphqls',
        'data': data.toJson(),
      };
      socket?.add(json.encode(message));
    } else {
      _sendHttpRequest(
        '/graphqls',
        json.encode(data.toJson()),
        (dynamic data) => null,
      );
    }
  }

  EventBus addSubscription(String field) {
    final ee = EventBus();
    subscriptions[field] = ee;
    return ee;
  }

  Future<Map<String, dynamic>> uploadFile(File file, String fileName) async {
    final ee = EventBus(sync: true);
    final completer = Completer<Map<String, dynamic>>();
    final requestId = _uuidGenerator.v1();
    // socket.emit(
    //   'fileupload',
    //   <String, dynamic>{
    //     'requestId': requestId,
    //     'file': file.readAsBytesSync(),
    //     'fileName': fileName,
    //   },
    // );
    _listenResponse(requestId, ee, completer);
    return completer.future;
  }

  Future<CurrentData?> checkCurrent() async {
    auth();
    if (bearer != null && bearer!.isNotEmpty) {
      return request(
        SingleRequest(
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
        SingleRequest(
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
        auth();
        return loginData;
      });

  Future<SignupData> signup(String email, String password) => request(
        SingleRequest(
          query: '''
          mutation(\$email:String!,\$password:String!) {
            signup(input: {email: \$email, password:\$password}) {
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
        final signupData = SignupData.fromJson(data);
        if (signupData != null && signupData.signup != null) {
          bearer = signupData.signup.bearer;
        }
        auth();
        return signupData;
      });

  Future<dynamic> logout() async {
    if (bearer != null && bearer!.isNotEmpty) {
      return request(
        SingleRequest(
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
