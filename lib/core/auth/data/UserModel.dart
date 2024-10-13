class UserModel {
  int? userId;
  String? username;
  String? email;
  String? passwordHash;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.userId,
        this.username,
        this.email,
        this.passwordHash,
        this.firstName,
        this.lastName,
        this.phone,
        this.address,
        this.city,
        this.state,
        this.country,
        this.postalCode,
        this.createdAt,
        this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    passwordHash = json['password_hash'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password_hash'] = this.passwordHash;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
