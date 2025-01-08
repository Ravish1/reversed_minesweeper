import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GameOverWidget extends StatelessWidget {
  final int discoveredBombs;
  final VoidCallback onPlayAgain;

  GameOverWidget({
    required this.discoveredBombs,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game Over Title
              Text(
                "🎉 Game Over! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Total Bombs Discovered
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(3, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Total Bombs Discovered",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$discoveredBombs",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        shadows: [
                          Shadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Play Again Button
              ElevatedButton(
                onPressed: () {
                  print('Button Pressed');
                  onPlayAgain();
                  
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Play Again",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lottie animation on top
        IgnorePointer(
          child: Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/animation/success.json',
                repeat: true,
                fit: BoxFit.fill, // Covers the entire screen
              ),
            ),
          ),
        ),
      ],
    );
  }
}
