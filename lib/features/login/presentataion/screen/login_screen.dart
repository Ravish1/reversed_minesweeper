import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reversed_minesweeper/features/game/bloc/game_bloc.dart';
import 'package:reversed_minesweeper/features/game/presentation/screen/game_screen.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/route_constants.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/login_event.dart';
import '../../bloc/login_state.dart';
import '../widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Builder(
        // Ensure context is within the BlocProvider
        builder: (context) {
          return Scaffold(
            body: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  context.go(RouteConstants.game);
                } else if (state is LoginFailure) {
                  print("BlocListener: LoginFailure detected: ${state.error}");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: _buildBody(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reversed Minesweeper",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  label: "Login with Google",
                  icon: Icons.login,
                  onPressed: () {
                    context.read<LoginBloc>().add(LoginWithGoogle());
                  },
                ),
                SizedBox(width: 20),
                CustomButton(
                  label: "Login as Guest",
                  icon: Icons.person,
                  onPressed: () {
                    redirectToGameSCreen(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void redirectToGameSCreen(BuildContext context) {
    AppRouter.setGuestLogin(true); // Set the guest login flag

    context.go(RouteConstants.game);
  }
}
