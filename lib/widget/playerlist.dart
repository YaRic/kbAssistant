import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbAssistant/widget/playerAvatar.dart';
import '../model/player.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PlayerList extends StatelessWidget {
  final double height;

  final List<Player> allplayers;

  final List<Player> toSell;

  final Function checkPlayer;

  final Function refreshFunction;

  String leagueId;

  PlayerList({
    this.height,
    this.allplayers,
    this.toSell,
    this.checkPlayer,
    this.refreshFunction,
    this.leagueId,
  });

  final _mioFormat = new NumberFormat.compact(locale: 'de_DE');
  final _kFormat = new NumberFormat("###,###", "de_DE");

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: () {
        return refreshFunction(leagueId);
      },
      child: Container(
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
                leading: PlayerAvatar(
                  firstName: allplayers[index].firstName,
                  lastName: allplayers[index].lastName,
                  teamId: allplayers[index].teamId,
                  radius: height * 0.05,
                ),
                title: Text("${allplayers[index].firstName} ${allplayers[index].lastName}"),
                subtitle: allplayers[index].offers[0].price > 1000000
                    ? Text("Angebot: " +
                        _mioFormat.format(allplayers[index].offers[0].price) +
                        " €")
                    : allplayers[index].offers[0].price > 10
                        ? Text("Angebot: " +
                            _kFormat.format(
                                allplayers[index].offers[0].price / 1000) +
                            "k €")
                        : Text(
                            "Kein Angebot",
                            style: TextStyle(color: Colors.red),
                          ),
                trailing: (allplayers[index].offers[0].price < 10)
                    ? Checkbox(value: null, tristate: true, onChanged: null)
                    : Checkbox(
                        value: toSell.contains(allplayers[index]),
                        tristate: true,
                        activeColor: Colors.green,
                        onChanged: (_) {
                          if (allplayers[index].offers[0].price > 10)
                            checkPlayer(allplayers[index]);
                        }),
              ),
            );
          },
          itemCount: allplayers.length,
        ),
      ),
    );
  }
}
