import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/placements.dart';
import '../model/user.dart';

class PaymentList extends StatefulWidget {
  final Placements placements;
  final double height;
  final double width;
  final List<User> userlist;

  const PaymentList({this.placements, this.height, this.userlist, this.width});

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  double paymentSumLastOne = 1;
  double paymentSumSecondLast = 2;
  double paymentSumThirdLast = 3;

  final _euroFormat = new NumberFormat("###,###", "de_DE");
  var textControllerLast = TextEditingController();
  var textControllerSecondLast = TextEditingController();
  var textControllerThirdLast = TextEditingController();

  final payFormat = NumberFormat.simpleCurrency(locale: "de_DE");

  _loadCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentSumLastOne = (prefs.getDouble('paymentSumLastOne') ?? 5);
      paymentSumSecondLast = (prefs.getDouble('paymentSumSecondLast') ?? 4);
      paymentSumThirdLast = (prefs.getDouble('paymentSumThirdLast') ?? 3);
      textControllerLast =
          TextEditingController(text: payFormat.format(paymentSumLastOne));
      textControllerSecondLast =
          TextEditingController(text: payFormat.format(paymentSumSecondLast));
      textControllerThirdLast =
          TextEditingController(text: payFormat.format(paymentSumThirdLast));
    });
  }

  _setCache(String last, String second, String third) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      paymentSumLastOne = double.parse(
          last.replaceAll(" ", "").replaceAll("€", "").replaceAll(",", "."));
      paymentSumSecondLast = double.parse(
          second.replaceAll(" ", "").replaceAll("€", "").replaceAll(",", "."));
      paymentSumThirdLast = double.parse(
          third.replaceAll(" ", "").replaceAll("€", "").replaceAll(",", "."));
      prefs.setDouble('paymentSumLastOne', paymentSumLastOne);
      prefs.setDouble('paymentSumSecondLast', paymentSumSecondLast);
      prefs.setDouble('paymentSumThirdLast', paymentSumThirdLast);
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

  String buildReadableListForClipboard(Map<String, double> list) {
    String result = "Zahlliste:\n\n";

    list.forEach((key, value) {
      result = result +
          "${widget.userlist.where((element) => element.userID == key).first.username}" +
          " -> " +
          payFormat.format(value) +
          "\n";
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> list = _calculatePayments();
    list.forEach((key, value) {
      print(key + " zahlt " + value.toString() + " €");
    });
    if (list.length < 3)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Liga zu klein um eine Zahlliste berechnen zu können",
          style: TextStyle(
            fontFamily: "Eurostile",
            fontSize: 23,
          ),
        ),
      );

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: new Icon(Icons.info),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              height: widget.height * 0.5,
                              child: AlertDialog(
                                title: Text(
                                    "Um das Kickbase Spiel noch spannender zu machen, hat sich unsere Liga dazu entschieden, dass die letzten drei jedes Spieltages gemeinsam in einen Topf einzahlen der gemeinsam am Ende der Saison auf den Kopf gehauen wird. \n \nDie Werte könnt ihr über die Einstellungen frei konfigurieren."),
                              ));
                        });
                  }),
              IconButton(
                  icon: new Icon(Icons.copy),
                  onPressed: () {
                    FlutterClipboard.copy(list.toString()).then(
                        (value) => print(buildReadableListForClipboard(list)));
                  }),
              IconButton(
                icon: new Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: widget.height * 0.5,
                        child: AlertDialog(
                          title: Text(
                              "Wieviel sollen die jeweils Spieltagsletzten zahlen?"),
                          content: Column(
                            children: [
                              Container(
                                width: widget.width * 0.2,
                                child: TextField(
                                  controller: textControllerLast,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Letzter",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: widget.height * 0.05,
                              ),
                              Container(
                                width: widget.width * 0.2,
                                child: TextField(
                                  controller: textControllerSecondLast,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Vorletzter",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: widget.height * 0.05,
                              ),
                              Container(
                                width: widget.width * 0.2,
                                child: TextField(
                                  controller: textControllerThirdLast,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Drittletzter",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            FlatButton(
                                child: Text('Abbrechen'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            FlatButton(
                              child: Text('Speichern'),
                              onPressed: () {
                                _setCache(
                                  textControllerLast.text,
                                  textControllerSecondLast.text,
                                  textControllerThirdLast.text,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
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
