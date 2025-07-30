import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import '../utils/PasswordVisibilityIcon.dart';
import '../utils/validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const String routeName = '/change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
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
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Password must be 8+ chars, include uppercase, lowercase, number, and special char',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      suffixIcon: PasswordVisibilityIcon(
                        isVisible: _confirmPasswordVisible,
                        onTap: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _onTapConfirmButton,
                    child: Text('Confirm'),
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

  void _onTapConfirmButton() {
    /*    if (_formKey.currentState!.validate()) {
      // TODO: Sign in with API
    }*/
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  void _onTapSignInButton() {
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
}
