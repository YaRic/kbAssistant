import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbAssistant/connector/kickbase.dart';
import 'package:kbAssistant/widget/login.dart';
import 'package:kbAssistant/widget/userInfo.dart';

import 'model/league.dart';
import 'model/user.dart';
import './model/player.dart';
import 'widget/budget.dart';

void main() {
  runApp(KbAssistant());
}

class KbAssistant extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Kickbase Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Your Kickbase Assistant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _mioFormat = new NumberFormat.compact(locale: 'de_DE');
  final _kFormat = new NumberFormat("###,###", "de_DE");

  Future<User> _currentUser;

  League currentLeague = new League("fakeID", "no League");

  bool _isloggedIn = false;

  Future<double> fetchedBudget;

  Future<List<Player>> fetchedPlayers;

  List<Player> toSell = new List<Player>();

  Future<User> _login(String username, String password) async {
    Future<User> loggedInUser = kickbaseLogin(username, password);

    setState(() {
      this._currentUser = loggedInUser;
      this._isloggedIn = true;
    });
    return loggedInUser;
  }

  void changeLeague(League league, String token, String username) {
    setState(() {
      this.currentLeague = league;
      this.fetchedBudget = fetchBudgetForLeague(league.id, token);
      this.fetchedPlayers =
          fetchPlayerForLeagueFromUser(league.id, username, token);
    });
  }

  void checkPlayer(Player player) {
    setState(() {
      if (toSell.contains(player)) {
        toSell.remove(player);
      } else {
        toSell.add(player);
      }
    });
  }

  double getSumToSell() {
    double sum = 0;
    toSell.forEach((element) {
      sum = sum + element.offers[0].price;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Der KB-Assi",
          style: TextStyle(
              fontFamily: "Eurostile",
              fontSize: 26,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ));
    final double netWidth = MediaQuery.of(context).size.width;
    final double netHeight = (MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    return Scaffold(
        appBar: appbar,
        body: Center(
          child: (!_isloggedIn)
              ? LoginPage(_login, changeLeague, netWidth, netHeight)
              : FutureBuilder<User>(
                  future: _currentUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          UserInfo(snapshot.data, currentLeague, changeLeague,
                              netWidth),
                          FutureBuilder<double>(
                            future: fetchedBudget,
                            builder: (context, snapshot) {
                              print(snapshot);
                              if (snapshot.hasData) {
                                return Budget((snapshot.data + getSumToSell()),
                                    netHeight);
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder(
                            future: fetchedPlayers,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // Next step: Extract this widget in a custom widget and try to play around with set value
                                return Container(
                                  height: netHeight * 0.75,
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
                                            radius: netWidth * 0.06,
                                            backgroundImage: NetworkImage(
                                                snapshot.data[index].coverURL),
                                          ),
                                          title: Text(
                                              "${snapshot.data[index].lastName}"),
                                          subtitle: snapshot.data[index]
                                                      .offers[0].price >
                                                  1000000
                                              ? Text("Angebot: " +
                                                  _mioFormat.format(snapshot
                                                      .data[index]
                                                      .offers[0]
                                                      .price) +
                                                  " €")
                                              : Text("Angebot: " +
                                                  _kFormat.format(snapshot
                                                      .data[index]
                                                      .offers[0]
                                                      .price / 1000) +
                                                  "k €"),
                                          trailing: Checkbox(
                                              value: toSell.contains(
                                                  snapshot.data[index]),
                                              onChanged: (_) {
                                                checkPlayer(
                                                    snapshot.data[index]);
                                              }),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return CircularProgressIndicator();
                            },
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ));
  }
}
