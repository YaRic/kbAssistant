import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget to display the current calculated budget
class Budget extends StatelessWidget {

  // Budget to display
  final double _budget;

  // planned height for this widget
  final double _height;

  // Number format to display that number
  final _euroFormatGerman = new NumberFormat("###,###", "de_DE");

  Budget(this._budget, this._height);

  // Method to decide the color (red for negative, green for positive values)
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
      height: _height,
      padding: EdgeInsets.only(
        top: _height * 0.12,
        bottom: _height * 0.12,
      ),
      child: Text("Kontostand: " + 
        _euroFormatGerman.format(_budget) + " €",
        style: TextStyle(
          color: getcolor(_budget),
          fontFamily: 'Century Gothic',
          fontSize: _height * 0.6,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
