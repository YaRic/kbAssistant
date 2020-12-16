import 'package:flutter/material.dart';
import 'package:kbAssistant/connector/kickbase.dart';
import 'package:kbAssistant/model/placements.dart';
import 'package:kbAssistant/widget/login.dart';
import 'package:kbAssistant/widget/paymentList.dart';
import 'package:kbAssistant/widget/playerlist.dart';
import 'package:kbAssistant/widget/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';

import 'model/league.dart';
import 'model/user.dart';
import './model/player.dart';
import 'widget/budget.dart';

void main() {
  runApp(KbAssistant());
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class KbAssistant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Kickbase Assistant',
      theme: ThemeData(
        primarySwatch: primaryBlack,
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
  String cacheMail;
  String cachePassword;

  Future<User> _currentUser;

  League currentLeague = new League("fakeID", "no League");

  bool _isloggedIn = false;

  Future<double> fetchedBudget;

  Future<List<Player>> fetchedPlayers;

  Future<Placements> fetchedPlacements;

  Future<List<User>> fetchedLeagueUsers;

  List<User> userlist;

  String currentToken;

  List<Player> toSell = new List<Player>();

  Future<User> _login(String mail, String password) async {
    Future<User> loggedInUser = kickbaseLogin(mail, password);

    setState(() {
      this._currentUser = loggedInUser;
      this._isloggedIn = true;
      _setCache(mail, password);
    });
    return loggedInUser;
  }

  Future<void> refresh() async {
    toSell.clear();
    _login(cacheMail, cachePassword).then((result) {
      changeLeague(result.leagues[0], result.accessToken, result.username,
          result.coverimageURL);
    });
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
      if ((cacheMail != "" && cachePassword != "") &&
          (cacheMail != null && cachePassword != null)) {
        _login(cacheMail, cachePassword).then((result) {
          currentToken = result.accessToken;
          if (currentLeague.id == "fakeID") currentLeague = result.leagues[0];
          changeLeague(currentLeague, result.accessToken, result.username,
              result.coverimageURL);
        });
      }
    });
  }

  _loadCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cacheMail = (prefs.getString('mail') ?? "");
    cachePassword = (prefs.getString('password') ?? "");
  }

  _setCache(String mail, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cacheMail = mail;
    cachePassword = password;
    prefs.setString('mail', cacheMail);
    prefs.setString('password', cachePassword);
  }

  void changeLeague(
      League league, String token, String username, String coverimageURL) {
    setState(() {
      this.currentToken = token;
      this.currentLeague = league;
      this.fetchedBudget = fetchBudgetForLeague(league.id, token);
      this.fetchedPlayers =
          fetchPlayerForLeagueFromUser(league.id, username, token);
      this.fetchedPlacements = fetchPlacements(league.id, token);
      this.fetchedLeagueUsers = fetchLeagueUser(league.id, token)
          .then((value) => this.userlist = value);
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
    var tabs = ["", "", ""];
    if (_isloggedIn) {
      tabs = ["+- Rechner", "Zahl-Liste", "MW-Steigerung"];
    }
    final double netWidth = MediaQuery.of(context).size.width;
    final double height = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    final appbar = AppBar(
      backgroundColor: Colors.black,
      title: Text(
        "Der KB-Assi",
        style: TextStyle(
            fontFamily: "Eurostile", fontSize: 26, fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
      bottom: TabBar(
        indicatorColor: Colors.white,
        isScrollable: true,
        tabs: [
          for (final tab in tabs)
            Center(
              child: Text(
                tab,
                style: TextStyle(fontFamily: 'Eurostile', fontSize: 18),
              ),
            ),
        ],
      ),
      actions: [
        Visibility(
          visible: _isloggedIn,
          child: new IconButton(
            icon: new Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ),
      ],
    );

    final double netHeight = (height - appbar.preferredSize.height);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
                            UserInfo(
                                user: snapshot.data,
                                currentLeague: currentLeague,
                                changeLeague: changeLeague,
                                width: netWidth,
                                height: netHeight * 0.1),
                            Container(
                              height: netHeight * 0.9,
                              width: netWidth,
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Column(children: [
                                    FutureBuilder<double>(
                                      future: fetchedBudget,
                                      builder: (context, snapshot) {
                                        print(snapshot);
                                        if (snapshot.hasData) {
                                          return Budget(
                                              (snapshot.data + getSumToSell()),
                                              netHeight * 0.06);
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
                                            height: 0.72 * netHeight,
                                            allplayers: snapshot.data,
                                            toSell: toSell,
                                            checkPlayer: checkPlayer,
                                            refreshFunction: refresh,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return CircularProgressIndicator();
                                      },
                                    ),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          (toSell.length > 0)
                                              ? Container(
                                                  width: 0.95 * netWidth,
                                                  child: SwipingButton(
                                                    text: "verkaufen",
                                                    onSwipeCallback: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Willst du folgende Spieler wirklich verkaufen?"),
                                                            content: Column(
                                                                children: toSell
                                                                    .map((e) =>
                                                                        Text(e
                                                                            .lastName))
                                                                    .toList()),
                                                            actions: [
                                                              FlatButton(
                                                                  child: Text(
                                                                      'Abbrechen'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }),
                                                              FlatButton(
                                                                child: Text(
                                                                    'Bestätigen'),
                                                                onPressed: () {
                                                                  sellPlayerList(
                                                                      toSell,
                                                                      currentLeague
                                                                          .id,
                                                                      currentToken);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  refresh();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    height: netHeight * 0.06,
                                                    backgroundColor:
                                                        Colors.black,
                                                    swipeButtonColor:
                                                        Colors.white,
                                                    iconColor: Colors.black,
                                                    swipePercentageNeeded: 0.9,
                                                    padding: EdgeInsets.only(
                                                      top: (netHeight * 0.03),
                                                    ),
                                                    buttonTextStyle: TextStyle(
                                                        fontFamily: 'Eurostile',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      top: (netHeight * 0.04)),
                                                  child: Text(
                                                    "Wähle Spieler aus um sie zu verkaufen",
                                                    style: TextStyle(
                                                        fontSize: netHeight *
                                                            0.06 *
                                                            0.4,
                                                        fontFamily: 'Eurostile',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                        ]),
                                  ]),
                                  FutureBuilder(
                                    future: fetchedPlacements,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return PaymentList(
                                          placements: snapshot.data,
                                          height: 0.8 * netHeight,
                                          userlist: this.userlist,
                                          width: netHeight * 0.8,
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                  Text(
                                    "In Entwicklung",
                                    style: TextStyle(
                                        fontFamily: "Eurostile", fontSize: 22),
                                  ),
                                ],
                              ),
                            ),
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
          )),
    );
  }
}
