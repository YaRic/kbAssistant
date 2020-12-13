import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/player.dart';

class PlayerList extends StatelessWidget {
  final double height;

  final List<Player> allplayers;

  final List<Player> toSell;

  final Function checkPlayer;

  PlayerList({this.height, this.allplayers, this.toSell, this.checkPlayer});

  final _mioFormat = new NumberFormat.compact(locale: 'de_DE');
  final _kFormat = new NumberFormat("###,###", "de_DE");

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(allplayers[index].coverURL),
              ),
              title: Text("${allplayers[index].lastName}"),
              subtitle: allplayers[index].offers[0].price > 1000000
                  ? Text("Angebot: " +
                      _mioFormat.format(allplayers[index].offers[0].price) +
                      " €")
                  : allplayers[index].offers[0].price > 10
                      ? Text("Angebot: " +
                          _kFormat.format(
                              allplayers[index].offers[0].price / 1000) +
                          "k €")
                      : Text("Kein Angebot", style: TextStyle(color: Colors.red),),
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
    );
    ;
  }
}
