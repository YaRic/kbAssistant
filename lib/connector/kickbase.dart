import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../model/player.dart';
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
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to login');
  }
}

Future<double> fetchBudgetForLeague(String leagueId, String token) async {
  final response = await http.get(
      'https://api.kickbase.com/leagues/${leagueId}/me',
      headers: {HttpHeaders.cookieHeader: "kkstrauth=${token};"});

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

Future<List<Player>> fetchPlayerForLeagueFromUser(String leagueId, String username, String token) async {
  final response = await http.get(
      'https://api.kickbase.com/leagues/${leagueId}/market',
      headers: {HttpHeaders.cookieHeader: "kkstrauth=${token};"});

  if (response.statusCode == 200) {
    return parsePlayerListFromMarketCall(jsonDecode(response.body), username);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch players for ${username}');
  }
}

List<Player> parsePlayerListFromMarketCall(json, String username) {
  var list = json['players'] as List;

  List<Player> result = list.map((entry) {
    Player currentEntry = Player.fromJson(entry);
    if (currentEntry.ownerUsername == username) {
      return currentEntry;
    }
  }).toList();

  result.removeWhere(
      (element) => (element == null));
  return result;
}
