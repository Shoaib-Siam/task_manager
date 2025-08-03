class UserModel{
  late String id;
  late String email;
  late String firstName;
  late String lastName;
  late String? mobileNumber;

  String get fullName => '$firstName $lastName';

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobile'];

  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobileNumber,
    };
  }


}