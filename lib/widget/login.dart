import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  Function _login;

  Function _changeLeague;

  double width;

  double height;

  LoginPage(this._login, this._changeLeague, this.width, this.height);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.height * 0.1),
      width: 0.8 * widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'username',
            ),
          ),
          SizedBox(
            height: widget.height * 0.02,
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'password',
            ),
          ),
          SizedBox(
            height: widget.height * 0.04,
          ),
          Container(
            width: 0.8 * widget.width,
            child: RaisedButton(
              color: Colors.black,
              onPressed: () {
                widget
                    ._login(usernameController.text, passwordController.text)
                    .then((result) {
                  widget._changeLeague(
                      result.leagues[0], result.accessToken, result.username);
                });
              },
              child: Text(
                "Login",
                style: TextStyle(
                    fontFamily: 'Eurostile',
                    color: Colors.white,
                    fontSize: widget.height * 0.03,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
