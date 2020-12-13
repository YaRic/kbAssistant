import './offer.dart';

class Player {
  String firstName;

  String lastName;

  String ownerUsername;

  double marketvalue;

  List<Offer> offers;

  String coverURL;

  bool toSell;

  Player({
    this.firstName,
    this.lastName,
    this.ownerUsername,
    this.marketvalue,
    this.offers,
    this.coverURL,
    this.toSell = false,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    String username;
    String coverURL;
    List<Offer> offers;

    if (json.containsKey('username')) {
      username = json["username"] == null ? "market" : json["username"];
    } else {
      username = "market";
    }

    if (json.containsKey('profile')) {
      coverURL = json["profile"] == null ? " - " : json["profile"];
    } else {
      coverURL = " - ";
    }

    if (json.containsKey('offers')) {
      offers = parseOffers(json['offers']);
    } else {
      List<Offer> fakeList = new List<Offer>();
      Offer fakeOffer = new Offer(price: 0, validUntil: new DateTime(2020));
      fakeList.add(fakeOffer);
      offers = fakeList;
    }
    return Player(
      firstName: json['firstName'],
      lastName: json['lastName'],
      ownerUsername: username,
      marketvalue: json['marketValue'],
      offers: offers,
      coverURL: coverURL,
    );
  }

  static List<Offer> parseOffers(offerjson) {
    var list = offerjson as List;
    List<Offer> offerList =
        list.map((entry) => new Offer.fromJson(entry)).toList();
    return offerList;
  }
}
