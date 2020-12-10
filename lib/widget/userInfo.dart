import 'package:flutter/material.dart';

import '../model/league.dart';
import '../model/user.dart';

class UserInfo extends StatelessWidget {
  final User user;

  final League currentLeague;

  final Function changeLeague;

  final double width;

  UserInfo(this.user, this.currentLeague, this.changeLeague, this.width);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: CircleAvatar(
            radius: width * 0.08,
            backgroundImage: NetworkImage(user.coverimageURL),
          ),
        ),
        Container(
          width: width * 0.7,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<League>(
              value: (currentLeague.name == "no League")
                  ? user.leagues[0]
                  : currentLeague,
              style: TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (League newValue) {
                changeLeague(newValue);
              },
              items:
                  user.leagues.map<DropdownMenuItem<League>>((League league) {
                return DropdownMenuItem<League>(
                  value: league,
                  child: Text(league.name),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
