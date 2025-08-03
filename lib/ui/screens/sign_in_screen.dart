import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import '../../data/urls.dart';
import '../controllers/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/snack_bar_message.dart';
import 'forgot_password_email_screen.dart';
import 'main_nav_holder_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signInInProgress = false;

  bool _passwordVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBg(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 180),
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: Validators.validatePassword,
                  ),
                  SizedBox(height: 20),

                  Visibility(
                    visible:
                        _signInInProgress == false, //signup button will visible
                    replacement:
                        CenteredCircularProgressIndicator(), //after 1tap signup button will not visible and progress indicator will visible
                    child: ElevatedButton(
                      onPressed: _signInInProgress ? null : _onTapSignInButton,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = _onTapSignUpButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    _signInInProgress = true;
    setState(() {});

    Map<String, String> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    _signInInProgress = false;
    setState(() {});

    if (response.success) {
      _emailController.clear();
      _passwordController.clear();

      UserModel userModel = UserModel.fromJson(response.body['data']);
      String token = response.body['token'];

      await AuthController.saveUserData(userModel, token);

      showSnackBarMessage(context, 'Sign in Successful');
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavHolderScreen.routeName,
        (predicate) => false,
      );
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Sign in failed. Please try again.',
      );
    }
  }

  void _onTapForgotPasswordButton() {
    Navigator.pushNamed(context, ForgotPasswordEmailScreen.routeName);
  }

  void _onTapSignUpButton() {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
