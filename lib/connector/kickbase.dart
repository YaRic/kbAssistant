import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/user.dart';

Future<User> kickbaseLogin(String username, String password) async {
  final http.Response response = await http.post(
    'https://api.kickbase.com/user/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': username,
      'password': password,
      'ext': 'false'
    }),
  );
  if (response.statusCode == 200) {
    print("Result from kickbase: " + response.body);
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to login');
  }
}
