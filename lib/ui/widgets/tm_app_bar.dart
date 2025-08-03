import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../screens/sign_in_screen.dart';
import '../screens/update_profile_screen.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({super.key});

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      title: GestureDetector(
        onTap: _onTapProfile,
        child: Row(
          children: [
            CircleAvatar(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(onPressed: _onTapLogoutButton, icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapLogoutButton() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.routeName,
      (predicate) => false,
    );
  }

  void _onTapProfile() {
    if (ModalRoute.of(context)?.settings.name !=
        UpdateProfileScreen.routeName) {
      Navigator.pushNamed(context, UpdateProfileScreen.routeName);
    }
  }
}
