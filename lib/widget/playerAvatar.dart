import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String teamId;

  final String firstName;

  final String lastName;

  final double radius;

  PlayerAvatar({this.teamId, this.firstName, this.lastName, this.radius});

  String capitalize(String s) => s[0].toUpperCase();

  static const teamColors = [
    {
      // Hertha
      "teamId": "20",
      "primaryColor": Color(0xFF0005eaa),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      //Union
      "teamId": "40",
      "primaryColor": Colors.red,
      "secondaryColor": Colors.yellow
    },
    {
      //Bielefeld
      "teamId": "22",
      "primaryColor": Color(0xFF0005eaa),
      "secondaryColor": Colors.black
    },
    {
      //Mainz
      "teamId": "18",
      "primaryColor": Color(0xFF0e62100),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      //Köln
      "teamId": "28",
      "primaryColor": Color(0xFF0eb2206),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      //Wolfsburg
      "teamId": "11",
      "primaryColor": Color(0xFF000a300),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      // Frankfurt
      "teamId": "4",
      "primaryColor": Color(0xFF0ce291f),
      "secondaryColor": Color(0xFF0000000)
    },
    {
      // Dortmund
      "teamId": "3",
      "primaryColor": Color(0xFF0ffe800),
      "secondaryColor": Color(0xFF0000000)
    },
    {
      // Freibung
      "teamId": "5",
      "primaryColor": Color(0xFF0000000),
      "secondaryColor": Colors.red
    },
    {
      // Gladbach
      "teamId": "15",
      "primaryColor": Color(0xFF0000000),
      "secondaryColor": Color(0xFF0009556)
    },
    {
      // Bayern
      "teamId": "2",
      "primaryColor": Color(0xFF0df2127),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      // Leipzig
      "teamId": "43",
      "primaryColor": Color(0xFF0e0223c),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      // Bremen
      "teamId": "10",
      "primaryColor": Color(0xFF0009556),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      // Stuttgart
      "teamId": "9",
      "primaryColor": Color(0xFF0ffffff),
      "secondaryColor": Color(0xFF0f22b1a)
    },
    {
      // Schalke
      "teamId": "8",
      "primaryColor": Color(0xFF00063aa),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      // Leverkusen
      "teamId": "7",
      "primaryColor": Color(0xFF0000000),
      "secondaryColor": Color(0xFF0e4210b)
    },
    {
      // Hoffenheim
      "teamId": "14",
      "primaryColor": Color(0xFF01c63b7),
      "secondaryColor": Color(0xFF0ffffff)
    },
    {
      // Augsburg
      "teamId": "13",
      "primaryColor": Color(0xFF0ba3733),
      "secondaryColor": Color(0xFF0347553)
    },
  ];

  get primaryColor {
    for (var team in teamColors) {
      if (team['teamId'] == this.teamId) {
        return team['primaryColor'];
      }
    }
  }

  get secondaryColor {
    for (var team in teamColors) {
      if (team['teamId'] == this.teamId) {
        return team['secondaryColor'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: this.radius,
      backgroundColor: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          child: Text(
            "${capitalize(firstName)}${capitalize(lastName)}",
            style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: radius),
          ),
        ),
      ),
    );
  }
}
