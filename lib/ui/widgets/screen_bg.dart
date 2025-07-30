import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/asset_path.dart';

class ScreenBg extends StatelessWidget {
  const ScreenBg({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetPaths.backgroundSvg,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        SafeArea(child: child),
      ],
    );
  }
}
