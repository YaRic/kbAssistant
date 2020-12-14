import './user.dart';

class Matchday {
  int matchDay;

  Map<int, User> table;

  Matchday({this.matchDay, this.table});

  factory Matchday.fromJson(Map<String, dynamic> json) {
    return Matchday(
      matchDay: json['day'],
      table: parseTable(json['users']),
    );
  }

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
