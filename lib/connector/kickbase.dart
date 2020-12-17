import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../model/offer.dart';
import '../model/placements.dart';
import '../model/player.dart';
import '../model/user.dart';

Future<User> kickbaseLogin(String username, String password) async {
  print("LOGIN CALL");
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
  print("BUDGET CALL");
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

Future<List<Player>> fetchPlayerForLeagueFromUser(
    String leagueId, String username, String token) async {
  print("PLAYER CALL");
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

  result.removeWhere((element) => (element == null));
  return result;
}

Future<Placements> fetchPlacements(String leagueId, String token) async {
  print("PLACEMENT CALL");
  final response = await http.get(
      'https://api.kickbase.com/leagues/${leagueId}/stats',
      headers: {HttpHeaders.cookieHeader: "kkstrauth=${token};"});

  if (response.statusCode == 200) {
    return Placements.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch placements for league');
  }
}

Future<List<User>> fetchLeagueUser(String leagueId, String token) async {
  print("LEAGUE USER CALL");
  final response = await http.get(
      'https://api.kickbase.com/leagues/${leagueId}/users',
      headers: {HttpHeaders.cookieHeader: "kkstrauth=${token};"});

  if (response.statusCode == 200) {
    return parseUserList(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch placements for league');
  }
}

List<User> parseUserList(json) {
  var list = json['users'] as List;

  List<User> result = list.map((entry) {
    return new User(
      userID: entry['id'],
      username: entry['name'],
      coverimageURL: entry['profile'],
    );
  }).toList();
  //result.removeWhere((element) => (element == null));
  return result;
}

Future<Map<Player, bool>> sellPlayerList(
    List<Player> playersToSell, String leagueId, String token) async {
  print("SELL PLAYER CALL");
  Map<Player, bool> result = new Map<Player, bool>();
  for (var player in playersToSell) {
    bool res = await sellPlayer(leagueId, player, token);
    result.putIfAbsent(player, () => res);
  }
  return result;
}

Future<bool> sellPlayer(String leagueId, Player player, String token) async {
  if (player.offers.length == 0) {
    return false;
  }

  Offer bestOffer;

  for (var offer in player.offers) {
    if (bestOffer == null) {
      bestOffer = offer;
    } else {
      if (bestOffer.price < offer.price) {
        bestOffer = offer;
      }
    }
  }

  final http.Response response = await http.post(
    'https://api.kickbase.com/leagues/${leagueId}/market/${player.id}/offers/${bestOffer.id}/accept',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': 'kkstrauth=${token}'
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<double> fetchBoughtForForUser(
    String playerId, String leagueId, String token) async {
  print("BOUGHT FOR CALL");
  final response = await http.get(
      'https://api.kickbase.com/leagues/${leagueId}/players/${playerId}/stats',
      headers: {HttpHeaders.cookieHeader: "kkstrauth=${token};"});

  if (response.statusCode == 200) {
    return parseBoughtForFromPlayerStatsCall(
        jsonDecode(response.body)['leaguePlayer']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch payed price for user');
  }
}

double parseBoughtForFromPlayerStatsCall(json) {
  return double.parse(json['buyPrice'].toString());
}

Future<List<Player>> enrichByBoughtValue(
    List<Player> players, String leagueId, String token) async {
  for (var player in players) {
    player.boughtFor = await fetchBoughtForForUser(player.id, leagueId, token);
  }
  return players;
}
