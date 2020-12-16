import 'dart:convert';

import 'package:kbAssistant/connector/kickbase.dart';

import 'league.dart';

class User {
  String userID;

  String username;

  String coverimageURL;

  List<League> leagues;

  String accessToken;

  User({
    this.userID,
    this.username,
    this.coverimageURL,
    this.leagues,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        leagues: parseLeageNameList(json['leagues']),
        username: getNameFromUserJSON(json['user']),
        coverimageURL: getCoverImageFromUserJSON(json['user']),
        accessToken: json['token'] as String);
  }

  static String getNameFromUserJSON(userJson) {
    return userJson['name'];
  }

  static String getCoverImageFromUserJSON(userJson) {
    return userJson['profile'];
  }

  static List<League> parseLeageNameList(leageJson) {
    var list = leageJson as List;
    List<League> leagueList = list.map((i) {
      if (i['ch'] == null) {
        return new League(
          i['id'].toString(),
          i['name'].toString(),
        );
      }
    }).toList();
    return leagueList.where((element) => element != null).toList();
  }
}
