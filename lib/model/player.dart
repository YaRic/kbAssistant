import './offer.dart';

// Object that represents a player
class Player {

  // ID of the player 
  String id;

  // Firstname of the player
  String firstName;

  // Last name of the player
  String lastName;

  // Username of the owner of the player
  String ownerUsername;

  // current market value 
  double marketvalue;

  // List of offers
  List<Offer> offers;

  // Link to the cover URL
  String coverURL;

  // price that was payed for this player by the owner
  double boughtFor;

  // Team ID of the Bundesliga club where the player plays
  String teamId;

  Player(
      {this.id,
      this.firstName,
      this.lastName,
      this.ownerUsername,
      this.marketvalue,
      this.offers,
      this.coverURL,
      this.boughtFor,
      this.teamId});

  // Factory that parse the json from http response market call to a Player object
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
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        ownerUsername: username,
        marketvalue: json['marketValue'],
        offers: offers,
        coverURL: coverURL,
        teamId: json['teamId']);
  }

  // Helper that parse the offer part of the response
  static List<Offer> parseOffers(offerjson) {
    var list = offerjson as List;
    List<Offer> offerList =
        list.map((entry) => new Offer.fromJson(entry)).toList();
    return offerList;
  }
}
