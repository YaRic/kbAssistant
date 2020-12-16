import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/player.dart';
import '../connector/kickbase.dart';

class MarketValueIncrease extends StatelessWidget {
  final List<Player> allPlayers;

  final double height;

  final String leagueId;

  final String token;

  MarketValueIncrease({
    this.allPlayers,
    this.height,
    this.leagueId,
    this.token,
  });

  final _mioFormat = new NumberFormat.compact(locale: 'de_DE');
  final _kFormat = new NumberFormat("###,###", "de_DE");
  final _percentageFormat = new NumberFormat.decimalPercentPattern();

  @override
  Widget build(BuildContext context) {
    Future<List<Player>> boughtValue = enrichByBoughtValue(allPlayers, leagueId, token);
    return Container(
      height: height,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: height * 0.06,
                backgroundImage: NetworkImage(allPlayers[index].coverURL),
              ),
              title: Text("${allPlayers[index].lastName}"),
              subtitle: allPlayers[index].marketvalue > 1000000
                  ? Text("Marktwert: " +
                      _mioFormat.format(allPlayers[index].marketvalue) +
                      " €")
                  : allPlayers[index].marketvalue > 10
                      ? Text("Marktwert: " +
                          _kFormat.format(
                              allPlayers[index].marketvalue / 1000) +
                          "k €")
                      : Text(
                          "Kein Angebot",
                          style: TextStyle(color: Colors.red),
                        ),
              trailing: FutureBuilder(
                future: boughtValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var dif = allPlayers[index].marketvalue - snapshot.data[index].boughtFor;
                    var percent = dif / snapshot.data[index].boughtFor;
                    var percentageColor;
                    if (percent > 0) {
                      percentageColor = Colors.green;
                    } else if (percent < 0) {
                      percentageColor = Colors.red;
                    }
                    return Text(
                      _percentageFormat.format(percent).toString(),
                      style: TextStyle(
                          fontSize: height * 0.04, color: percentageColor),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          );
        },
        itemCount: allPlayers.length,
      ),
    );
  }
}
