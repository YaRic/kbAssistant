import 'package:flutter/material.dart';
import 'package:kbAssistant/connector/kickbase.dart';
import 'package:kbAssistant/widget/login.dart';
import 'package:kbAssistant/widget/userInfo.dart';

import 'model/league.dart';
import 'model/user.dart';
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
  Future<User> _currentUser;

  League currentLeague = new League("fakeID", "no League");

  bool _isloggedIn = false;

  Future<double> fetchedBudget;

  Future<User> _login(String username, String password) async {
    Future<User> loggedInUser = kickbaseLogin(username, password);

    setState(() {
      this._currentUser = loggedInUser;
      this._isloggedIn = true;
    });
    return loggedInUser;
  }

  void changeLeague(League league, String token) {
    setState(() {
      this.currentLeague = league;
      this.fetchedBudget = fetchBudgetForLeague(league.id, token);
    });
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
              ? LoginPage(_login, changeLeague ,netWidth, netHeight)
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
                                return Budget(snapshot.data, netHeight);
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return CircularProgressIndicator();
                            },
                          ),
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
