import './matchday.dart';

class Placements {
  int currentDay;

  List<Matchday> matchdays;

  Placements({this.currentDay, this.matchdays});

  factory Placements.fromJson(Map<String, dynamic> json) {
    return Placements(
        currentDay: json['currentDay'],
        matchdays: parseMatchdays(json['matchDays']));
  }

  static List<Matchday> parseMatchdays(matchDayJSON) {
    var list = matchDayJSON as List;
    List<Matchday> result = list.map((i) {
      return new Matchday.fromJson(i);
    }).toList();

    return result;
  }
}
