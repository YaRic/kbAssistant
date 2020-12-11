class Offer {
  double price;

  DateTime validUntil;

  Offer({this.price, this.validUntil});

  factory Offer.fromJson(Map<String, dynamic> json) {
    DateTime validUntil = new DateTime(2222);

    if (json.containsKey('validUntilDate')) {
      validUntil = DateTime.parse(json['validUntilDate']);
    }

    return Offer(
      price: json['price'],
      validUntil: validUntil,
    );
  }
}
