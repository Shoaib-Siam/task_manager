import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_bg.dart';

import '../utils/asset_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBg(
        child: Center(child: SvgPicture.asset(AssetPaths.logoSvg)),
      ),
    );
  }
}
