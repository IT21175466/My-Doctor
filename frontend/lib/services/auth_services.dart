import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_doctor/repositories/auth_repository.dart';

class AuthServices {
  final AuthRepository _authRepository = AuthRepository();

  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? signInAuthentication =
          await googleSignInUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: signInAuthentication?.accessToken,
        idToken: signInAuthentication?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('Email - ${userCredential.user?.email}'
          'ID - ${userCredential.user?.uid}');

      await _authRepository.loginWithGoogle(
          userCredential.user?.email, userCredential.user?.uid);
    } catch (e) {
      print('G SignIn Error: $e');
    }
  }

  Future<void> signOutFromGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }
}
