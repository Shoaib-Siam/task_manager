import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccessful = false;
    _inProgress = true;
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

    _inProgress = false;
    update();
    return isSuccessful;
  }
}
