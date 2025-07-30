import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import 'change_password_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  static const String routeName = '/pin-verification';

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'A 6-digit code has been sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  PinCodeTextField(
                    length: 6,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.green,
                      selectedFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    controller: _pinController,

                    appContext: context,
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _onTapVerifyButton,
                    child: Text('Verify'),
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

  void _onTapVerifyButton() {
    /*    if (_formKey.currentState!.validate()) {
      // TODO: Sign in with API
    }*/
    Navigator.pushNamed(context, ChangePasswordScreen.routeName);
  }

  void _onTapSignInButton() {
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  @override
  void dispose() {
    _pinController.dispose();

    super.dispose();
  }
}
