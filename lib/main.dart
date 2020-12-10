import 'package:flutter/material.dart';
import 'package:kbAssistant/connector/kickbase.dart';
import 'package:kbAssistant/widget/login.dart';
import 'package:kbAssistant/widget/userInfo.dart';

import 'model/league.dart';
import 'model/user.dart';

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

  void _login(String username, String password) {
    Future<User> loggedInUser = kickbaseLogin(username, password);

    setState(() {
      this._currentUser = loggedInUser;
      this._isloggedIn = true;
    });
    print(loggedInUser);
  }

  void changeLeague(League league) {
    setState(() {
      this.currentLeague = league;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
        title: Text(
      "Der KB-Assi",
      style: TextStyle(fontFamily: "Eurostile", fontSize: 26),
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
              ? LoginPage(_login, netWidth, netHeight)
              : FutureBuilder<User>(
                  future: _currentUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          UserInfo(snapshot.data, currentLeague, changeLeague,
                              netWidth),
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
