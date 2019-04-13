import 'dart:convert';
import 'package:http/http.dart';

Future<String> uploadFirebase(String uploadPath, String filePath) async {
  const URL =
      'https://firebasestorage.googleapis.com/v0/b/fastter-todo.appspot.com';
  final uri = Uri.parse('$URL/o?name=$uploadPath');
  final request = MultipartRequest('POST', uri);
  request.files.add(await MultipartFile.fromPath('picture', filePath));

  final response = await request.send();
  final resp = await Response.fromStream(response);
  final Map<String, dynamic> respJson = json.decode(resp.body);
  final url =
      '$URL/o/${uploadPath.replaceAll("/", "%2F")}?alt=media&token=${respJson["downloadTokens"]}';
  return url;
}
