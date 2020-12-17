import 'package:flutter/material.dart';

// Widget for the Login page
class LoginPage extends StatefulWidget {
  // Function that should be executed after user fill the form
  final Function _login;

  // Function that changes the league (here used to trigger the display infomation, otherwise no data will be displayed after login)
  final Function _changeLeague;

  // width the widget should take
  final double width;

  // height the widget should take
  final double height;


  LoginPage(this._login, this._changeLeague, this.width, this.height);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Controller to detect changes on the unsermane text field
  final usernameController = TextEditingController();

  // Controller to detect changes on the unsermane password field
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
              hintText: 'mail',
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
                  widget._changeLeague(result.leagues[0], result.accessToken,
                      result.username, result.coverimageURL);
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
