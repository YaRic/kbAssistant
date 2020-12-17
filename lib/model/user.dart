import 'league.dart';

// Class that represents the object (kickbase) User
class User {

  // Kickbase user ID - given by kickbase
  String userID;

  // Username - choosen by customer
  String username;

  // Link to profile pic
  String coverimageURL;

  // leavues of the user
  List<League> leagues;

  // Access Token of the user
  String accessToken;

  User({
    this.userID,
    this.username,
    this.coverimageURL,
    this.leagues,
    this.accessToken,
  });

  // factory to parse the json response into an user object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        leagues: parseLeageNameList(json['leagues']),
        username: getNameFromUserJSON(json['user']),
        coverimageURL: getCoverImageFromUserJSON(json['user']),
        accessToken: json['token'] as String);
  }

  // helper to parse username
  static String getNameFromUserJSON(userJson) {
    return userJson['name'];
  }

  // helper to parse profile pic
  static String getCoverImageFromUserJSON(userJson) {
    return userJson['profile'];
  }

  // helper to parse leage list of the customer 
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
