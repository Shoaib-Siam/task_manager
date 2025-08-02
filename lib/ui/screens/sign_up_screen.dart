import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../utils/PasswordVisibilityIcon.dart';
import '../utils/validators.dart';
import '../widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signUPInProgress = false;

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
                  SizedBox(height: 90),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _mobileNumberController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Mobile Number'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your mobile number';
                      }
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value.trim())) {
                        return 'Enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: PasswordVisibilityIcon(
                        isVisible: _passwordVisible,
                        onTap: () {
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
                        _signUPInProgress == false, //signup button will visible
                    replacement:
                        CenteredCircularProgressIndicator(), //after 1tap signup button will not visible and progress indicator will visible

                    child: ElevatedButton(
                      onPressed: _signUPInProgress ? null : _onTapSignUpButton,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
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

  void _onTapSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _signUPInProgress = true;
    setState(() {});
    Map<String, String> requestBody = {
      'email': _emailController.text.trim(),
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'mobileNumber': _mobileNumberController.text.trim(),
      'password': _passwordController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );
    _signUPInProgress = false;
    setState(() {});

    if (response.success) {
      _clearTextFields();
      showSnackBarMessage(context, 'Registration Successful');
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, SignInScreen.routeName);
      });
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Registration failed. Please try again.',
      );
    }
  }

  void _clearTextFields() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileNumberController.clear();
    _passwordController.clear();
  }

  void _onTapSignInButton() {
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
