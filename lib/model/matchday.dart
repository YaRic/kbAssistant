import './user.dart';

// Object that represents a matchday
class Matchday {

  //Number of the matchday example "1" for first matchday of the season
  int matchDay;

  // Represents the table for one matchday, Map of place and user
  Map<int, User> table;

  Matchday({this.matchDay, this.table});

  // Factory that creates an matchday out of on json response of placements
  factory Matchday.fromJson(Map<String, dynamic> json) {
    return Matchday(
      matchDay: json['day'],
      table: parseTable(json['users']),
    );
  }

  // Helper method that parse the table part of the response (called by factory)
  static Map<int, User> parseTable(tableJSON) {
    var list = tableJSON as List;
    Map<int, User> table = new Map<int, User>();
    for (var item in list) {
      table.putIfAbsent(
          item['dayPlacement'], () => new User(userID: item['userId']));
    }
    return table;
  }
}
