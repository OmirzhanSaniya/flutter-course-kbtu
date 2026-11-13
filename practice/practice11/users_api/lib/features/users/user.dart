// Level 2: a model that survives. Every `as` is a claim about the
// JSON; if the server breaks it, the cast throws and names the field.

class Geo {
  const Geo({required this.lat, required this.lng});

  final double lat;
  final double lng;

  // The server sends "-37.3159" (a String), we store a double.
  // BREAK IT (Level 2): json['lat'] as double ->
  // type 'String' is not a subtype of type 'double' in type cast
  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
    lat: double.parse(json['lat'] as String),
    //lat:json['lat'] as double,
    lng: double.parse(json['lng'] as String),
  );

  Map<String, dynamic> toJson() => {
    'lat': lat.toString(),
    'lng': lng.toString(),
  };
}

class Address {
  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json['street'] as String,
    suite: json['suite'] as String,
    city: json['city'] as String,
    zipcode: json['zipcode'] as String,
    geo: Geo.fromJson(json['geo'] as Map<String, dynamic>), // nested
  );

  Map<String, dynamic> toJson() => {
    'street': street,
    'suite': suite,
    'city': city,
    'zipcode': zipcode,
    'geo': geo.toJson(),
  };
}

typedef Company = ({String name, String catchPhrase});

class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    this.website,
    required this.address,
    required this.company,
  });

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone; // raw, as the server sent it
  final String? website; // the only optional field
  final Address address;
  final Company company; // a record

  // keeps only digits and +: "1-770-736-8031 x56442" -> "1770736803156442"
  String get phoneDigits => phone.replaceAll(RegExp(r'[^0-9+]'), '');

  factory User.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>;
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String?,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      company: (
        name: company['name'] as String,
        catchPhrase: company['catchPhrase'] as String,
      ),
    );
  }

  // The same shape the server sent, nested maps included.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'website': website,
    'address': address.toJson(),
    'company': {'name': company.name, 'catchPhrase': company.catchPhrase},
  };

  // Two users are the same user when the ids match.
  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(#$id $name, ${address.city})';
}
