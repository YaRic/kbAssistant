import './matchday.dart';

// Object that represents the placements for the current season
class Placements {

  // Number that represents the current matchday
  int currentDay;

  // List of matchdays
  List<Matchday> matchdays;

  Placements({this.currentDay, this.matchdays});

  // Factory that creates Placement object by parsing the response json 
  factory Placements.fromJson(Map<String, dynamic> json) {
    return Placements(
        currentDay: json['currentDay'],
        matchdays: parseMatchdays(json['matchDays']));
  }

  // parse Matchdays part of the json by using the factory of matchday class
  static List<Matchday> parseMatchdays(matchDayJSON) {
    var list = matchDayJSON as List;
    List<Matchday> result = list.map((i) {
      return new Matchday.fromJson(i);
    }).toList();

    return result;
  }
}
