import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reversed_minesweeper/features/splash/presentation/splash_screen.dart';
import 'package:reversed_minesweeper/routes/app_router.dart';
import 'features/game/bloc/game_bloc.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(ReversedMinesweeper());
}

class ReversedMinesweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router, // Use the configured router
    );
  }
}
