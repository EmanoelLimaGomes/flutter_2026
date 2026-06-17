class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? token;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.token,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
