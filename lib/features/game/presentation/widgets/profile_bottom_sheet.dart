import 'package:flutter/material.dart';
import '../../../../helpers/shared_pref.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/route_constants.dart';
import '../../../login/presentataion/screen/login_screen.dart';
import '../../bloc/game_bloc.dart';
import '../../bloc/game_event.dart';

class ProfileBottomSheet extends StatelessWidget {
  final String? userName;
  final String? email;

  const ProfileBottomSheet({Key? key, this.userName, this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Icon
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Profile Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.orangeAccent),
            ),
            SizedBox(height: 16),
            // User Name
            Text(
              userName ?? "Guest",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            // Email
            Text(
              email ?? "No Email Available",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 24),
            // Sign Out Button
            ElevatedButton(
              onPressed: () async {
                // Clear SharedPreferences and logout from Google
                await SharedPrefsHelper().clearUserData();
                await GoogleSignIn().signOut();

                Navigator.of(context).pop(); // Close bottom sheet
                context.go(RouteConstants.login); // Navigate to the LoginScreen and clear the stack

              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.redAccent, backgroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
