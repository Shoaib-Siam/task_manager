import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/pin_verification_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../utils/validators.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  static const String routeName = '/forgot-password-email';

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _verifyEmailInProgress = false;

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
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'A 6-digit code will be sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: Validators.validateEmail,
                  ),

                  SizedBox(height: 20),

                  Visibility(
                    visible: _verifyEmailInProgress == false,
                    replacement: CircularProgressIndicator(),

                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account?",
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

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _verifyEmail();
    }
  }

  void _onTapSignInButton() {
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  Future<void> _verifyEmail() async {
    _verifyEmailInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.verifyEmailUrl(_emailController.text.trim()),
    );

    if (response.success) {
      if (mounted) {
        showSnackBarMessage(context, 'Verification code sent to your email.');
        Navigator.pushNamed(
          context,
          PinVerificationScreen.routeName,
          arguments: _emailController.text.trim(),
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Something went wrong. Please try again.',
        );
      }
    }
    _verifyEmailInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }
}
