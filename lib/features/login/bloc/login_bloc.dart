import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../helpers/shared_pref.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<LoginAsGuest>(_onLoginAsGuest);
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoading());

      // Perform Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        emit(LoginFailure("Google Sign-In canceled"));
        return;
      }

      // Authenticate with Firebase
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;


      if (user != null) {
        // Save login status and user details in shared preferences
        await SharedPrefsHelper().saveGoogleLoginStatus(
          isLoggedIn: true,
          userName: user.displayName,
          email: user.email,
        );

        emit(LoginSuccess(
          userName: user.displayName,
          email: user.email,
        ));
      } else {
        emit(LoginFailure("Google Sign-In failed to retrieve user details"));
      }
    } catch (e) {
      print("Exceptionnnn: $e");
      emit(LoginFailure("Google Sign-In failed: $e"));
    }
  }

  void _onLoginAsGuest(
      LoginAsGuest event, Emitter<LoginState> emit) async {

    // Save guest login status
    await SharedPrefsHelper().saveGuestLoginStatus(isLoggedIn: true);

    emit(LoginSuccess(userName: "Guest", email: null));
  }
}
