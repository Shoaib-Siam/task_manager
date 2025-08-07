class UserModel {
  late String id;
  late String email;
  late String firstName;
  late String lastName;
  String? mobileNumber;
  String? photo;

  String get fullName => '$firstName $lastName';

  UserModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['_id'];
    email = jsonData['email'];
    firstName = jsonData['firstName'];
    lastName = jsonData['lastName'];
    mobileNumber = jsonData['mobile'];
    photo = jsonData['photo'];
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobileNumber,
      'photo': photo,
    };
  }
}
