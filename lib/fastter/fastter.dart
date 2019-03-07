import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_bus/event_bus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import '../models/user.model.dart';

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

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'jwtToken': jwtToken,
        'apiToken': apiToken,
        'query': query,
        'variables': variables,
      };
}

class Fastter {
  final String url;
  IO.Socket socket;
  Map<String, EventBus> requests;
  Map<String, EventBus> subscriptions;
  String apiToken;

  String bearer;
  User user;

  Fastter(this.url, String apiToken) {
    requests = {};
    subscriptions = {};
    this.apiToken = apiToken;
  }

  connect() async {
    socket = IO.io(url, <dynamic, dynamic>{
      'forceNew': true,
      'transports': ['websocket']
    });
    socket.on('connect', (_) {
      print('connected');
    });
    socket.on('graphqlResponse', (dynamic data) {
      this.requests[data['requestId']].fire(data);
    });
    socket.on('disconnect', (_) => print('disconnect'));
    socket.connect();
  }

  Future<Map<String, dynamic>> request(Request data) {
    var completer = new Completer<Map<String, dynamic>>();
    EventBus ee = new EventBus(sync: true);
    ee.on().listen((resp) {
      // response.data = (response.type).fromJson(resp['data']);
      if (resp['errors'] != null && resp['errors'].length > 0) {
        throw new FastterError(resp['errors'][0]);
      } else if (resp['data'] != null) {
        // resolve(response)
        completer.complete(resp['data']);
      } else {
        throw new FastterError(resp);
      }
      if (requests.containsKey(data.requestId)) {
        requests[data.requestId].destroy();
        requests.remove(data.requestId);
      }
    });
    Uuid uuidGenerator = new Uuid();
    String uuid = uuidGenerator.v1();
    this.requests[uuid] = ee;
    if (socket != null) {
      data.requestId = uuid;
      if (bearer != null) {
        data.jwtToken = bearer;
      }
      if (apiToken != null) {
        data.apiToken = apiToken;
      }
      try {
        socket.emit('graphql', data.toJson());
      } catch (error) {
        throw FastterError(error);
      }
    } else {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      if (bearer != null) {
        headers['Authorization'] = bearer;
      }
      if (apiToken != null) {
        headers['API_TOKEN'] = apiToken;
      }
      try {
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
          ee.fire(json.decode(response.body));
        }).catchError(completer.completeError);
      } catch (error) {
        completer.completeError(error);
      }
    }
    return completer.future;
  }

  Future<LoginData> login(String email, String password) {
    return request(
      new Request(
        query: '''
          mutation(\$email:String!,\$password:String!) {
            login(input: {email: \$email, password:\$password}) {
              bearer
              user { _id, email }
            }
          }''',
        variables: {
          'email': email,
          'password': password,
        },
      ),
    ).then((dynamic resp) {
      LoginData response = LoginData.fromJson(resp);
      if (response != null && response.login != null) {
        bearer = response.login.bearer;
      }
      return response;
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
    ).then((response) {
      bearer = null;
      return response;
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
