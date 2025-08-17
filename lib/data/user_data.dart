class UserData {
  int? id;
  int? roleId;
  String? email;
  String? phoneNumber;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? firstName;
  String? avatar;
  String? profileImage;
  String? businessType;

  UserData({
    this.id,
    this.roleId,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.firstName,
    this.avatar,
    this.profileImage,
    this.businessType,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    address = json['address_one'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    firstName = json['first_name'];
    avatar = json['avatar'];
    profileImage = json['profile_image'];
    businessType = json['business_type'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'email': email,
      'phone_number': phoneNumber,
      'address_one': address,
      'city': city,
      'state': state,
      'country': country,
      'zipcode': zipcode,
      'first_name': firstName,
      'avatar': avatar,
      'profile_image': profileImage,
      'business_type': businessType,
    };
  }
}
