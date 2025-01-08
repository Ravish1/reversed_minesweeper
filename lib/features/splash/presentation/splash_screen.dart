import 'dart:async';
import 'package:flutter/material.dart';
import '../../../helpers/shared_pref.dart';
import '../../../routes/route_constants.dart';
import '../../game/presentation/screen/game_screen.dart';
import '../../login/presentataion/screen/login_screen.dart';
import 'package:go_router/go_router.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(Duration(milliseconds: 50), (timer) async {
      setState(() {
        if (_progress < 100) {
          _progress += 2; // Increase progress
        } else {
          timer.cancel();
          _checkLoginStatus(); // Check login status after loading completes
        }
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    // Let GoRouter handle redirection
    context.go(RouteConstants.login); // Simply navigate; GoRouter will redirect
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Centered content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    "Reversed Minesweeper",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: LinearProgressIndicator(
                      value: _progress / 100, // Convert progress to 0-1 range
                      backgroundColor: Colors.white.withOpacity(0.5),
                      color: Colors.white,
                      minHeight: 8,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Progress percentage
                  Text(
                    "Loading....${_progress.toInt()}%",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Footer text
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Crafted with ❤️ by Ravish",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
