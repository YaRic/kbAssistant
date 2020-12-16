import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/placements.dart';
import '../model/user.dart';

class PaymentList extends StatefulWidget {
  final Placements placements;
  final double height;
  final List<User> userlist;

  const PaymentList({this.placements, this.height, this.userlist});

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  double paymentSumLastOne = 1;
  double paymentSumSecondLast = 2;
  double paymentSumThirdLast = 3;

  final _euroFormat = new NumberFormat("###,###", "de_DE");

  _loadCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentSumLastOne = (prefs.getDouble('paymentSumLastOne') ?? 5);
      paymentSumSecondLast = (prefs.getDouble('paymentSumSecondLast') ?? 4);
      paymentSumThirdLast = (prefs.getDouble('paymentSumThirdLast') ?? 3);
    });
  }

  Map<String, double> _calculatePayments() {
    Map<String, double> payTable = new Map<String, double>();

    for (var md in widget.placements.matchdays) {
      if (md.table.length < 3) {
        return {'Liga zu klein': 0};
      }
      payTable.putIfAbsent((md.table[md.table.length].userID), () => 0);
      payTable.putIfAbsent((md.table[md.table.length - 1].userID), () => 0);
      payTable.putIfAbsent((md.table[md.table.length - 2].userID), () => 0);

      payTable.update(md.table[md.table.length].userID,
          (value) => value + paymentSumLastOne);
      payTable.update(md.table[md.table.length - 1].userID,
          (value) => value + paymentSumSecondLast);
      payTable.update(md.table[md.table.length - 2].userID,
          (value) => value + paymentSumThirdLast);
    }
    var sortedMap = Map.fromEntries(payTable.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
    return sortedMap;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> list = _calculatePayments();
    list.forEach((key, value) {
      print(key + " zahlt " + value.toString() + " €");
    });
    if (list.length < 3) return Text("Liga zu klein");

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Zahlliste: ",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Eurostile",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(icon: new Icon(Icons.settings), onPressed: null)
        ],
      ),
      Container(
        height: widget.height,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            String user = list.keys.elementAt(index);
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: widget.height * 0.05,
                  backgroundImage: NetworkImage(
                      "${widget.userlist.where((element) => element.userID == user).first.coverimageURL}"),
                ),
                title: Text(
                    "${widget.userlist.where((element) => element.userID == user).first.username}",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Eurostile",
                    )),
                trailing: Text(
                  "${_euroFormat.format(list[user])} €",
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Eurostile",
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          itemCount: list.length,
        ),
      ),
    ]);
  }
}
