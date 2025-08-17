import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  bool _signInInProgress = false;

  String? _errorMessage;

  bool get signInInProgress => _signInInProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccessful = false;
    _signInInProgress = true;
    update();

    Map<String, String> requestBody = {"email": email, "password": password};

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
      isFromLogin: true,
    );

    if (response.success) {
      UserModel userModel = UserModel.fromJson(response.body['data']);
      String token = response.body['token'];

      await AuthController.saveUserData(userModel, token);
      isSuccessful = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _signInInProgress = false;
    update();
    return isSuccessful;
  }
}
