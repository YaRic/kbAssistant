// Object that represents an offer
class Offer {

  // Id of an Offer (important to accept it later for example)
  String id;

  // price / value of the offer
  double price;

  // time until the offer is valid
  DateTime validUntil;

  Offer({
    this.id,
    this.price,
    this.validUntil,
  });

  // Facotry that creates an offer out of an json response part
  factory Offer.fromJson(Map<String, dynamic> json) {
    DateTime validUntil = new DateTime(2222);

    if (json.containsKey('validUntilDate')) {
      validUntil = DateTime.parse(json['validUntilDate']);
    }

    return Offer(
      id: json['id'],
      price: json['price'],
      validUntil: validUntil,
    );
  }
}
