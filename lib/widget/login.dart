import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  Function _login;

  double width;

  double height;

  LoginPage(this._login, this.width, this.height);

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
          SizedBox(height: widget.height * 0.02,),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'password',
            ),
          ),
          SizedBox(height: widget.height * 0.04,),
          Container(
            width: 0.8 * widget.width,
            child: RaisedButton(
              onPressed: () {
                widget._login(usernameController.text, passwordController.text);
              },
              child: Text("Login"),
            ),
          ),
        ],
      ),
    );
  }
}
