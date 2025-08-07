class UserModel {
  late String id;
  late String email;
  late String firstName;
  late String lastName;
  late String? mobileNumber;

  String get fullName => '$firstName $lastName';

  UserModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['_id'];
    email = jsonData['email'];
    firstName = jsonData['firstName'];
    lastName = jsonData['lastName'];
    mobileNumber = jsonData['mobile'];
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
