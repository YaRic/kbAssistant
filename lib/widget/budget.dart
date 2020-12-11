import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Budget extends StatelessWidget {
  final double _budget;

  final double _height;

  final _euroFormatGerman = new NumberFormat("###,###", "de_DE");

  Budget(this._budget, this._height);

  Color getcolor(double budget) {
    if (budget < 0) {
      return Colors.red;
    } else if (budget > 0) {
      return Colors.green;
    } else
      return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: _height * 0.02,
        bottom: _height * 0.02,
      ),
      child: Text("Kontostand: " + 
        _euroFormatGerman.format(_budget) + " €",
        style: TextStyle(
          color: getcolor(_budget),
          fontFamily: 'Eurostile',
          fontSize: _height * 0.03,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
