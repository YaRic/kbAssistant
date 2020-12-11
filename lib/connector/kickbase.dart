import 'dart:convert';
import 'dart:io';

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

Future<double> fetchBudgetForLeague(String LeagueId, String token) async {
  final response =
      await http.get('https://api.kickbase.com/leagues/${LeagueId}/me', headers: {HttpHeaders.cookieHeader: "kkstrauth=${token};"});

  if (response.statusCode == 200) {
    return parseBudgetFromLeagueMeCall(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch current budget');
  }
}

double parseBudgetFromLeagueMeCall(json) {
  String stringResult = json['budget'].toString();
  return double.parse(stringResult);
}
