import 'package:flutter/material.dart';
import 'package:kbAssistant/connector/kickbase.dart';
import 'package:kbAssistant/widget/login.dart';
import 'package:kbAssistant/widget/playerlist.dart';
import 'package:kbAssistant/widget/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String cacheUsername;
  String cachePassword;

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
      _setCache(username, password);
    });
    return loggedInUser;
  }

  void logout() {
    setState(() {
      _setCache("", "");
      _isloggedIn = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCache().then((result) {
      if ((cacheUsername != "" && cachePassword != "") &&
          (cacheUsername != null && cachePassword != null)) {
        _login(cacheUsername, cachePassword).then((result) {
          changeLeague(result.leagues[0], result.accessToken, result.username,
              result.coverimageURL);
        });
      }
    });
  }

  _loadCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cacheUsername = (prefs.getString('username') ?? "");
    cachePassword = (prefs.getString('password') ?? "");
  }

  _setCache(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cacheUsername = username;
    cachePassword = password;
    prefs.setString('username', cacheUsername);
    prefs.setString('password', cachePassword);
  }

  void changeLeague(
      League league, String token, String username, String coverimageURL) {
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
            fontFamily: "Eurostile", fontSize: 26, fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
      actions: [
        new IconButton(
          icon: new Icon(Icons.logout),
          onPressed: () {
            logout();
          },
        ),
      ],
    );
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
                                return Text(
                                  "Budget nicht verfügbar",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                          FutureBuilder(
                            future: fetchedPlayers,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return PlayerList(
                                  height: 0.75 * netHeight,
                                  allplayers: snapshot.data,
                                  toSell: toSell,
                                  checkPlayer: checkPlayer,
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
                      return Column(children: [
                        Text(
                          "Login fehlgeschlagen",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        LoginPage(_login, changeLeague, netWidth, netHeight)
                      ]);
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ));
  }
}
