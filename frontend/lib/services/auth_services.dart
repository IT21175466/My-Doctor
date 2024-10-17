import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_doctor/repositories/auth_repository.dart';

class AuthServices {
  final AuthRepository _authRepository = AuthRepository();

  signInWithGoogle() async {
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

    await _authRepository.loginWithGoogleAndFacebook(
        userCredential.user?.email, userCredential.user?.uid);
  }

  Future<void> signOutFromGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
  }

  Future<void> signOutFromFacebook() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
  }

  //Facebook login
  signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email'],
    );

    if (loginResult.status == LoginStatus.success) {
      final AccessToken? accessToken = loginResult.accessToken;

      if (accessToken != null) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in to Firebase with the Facebook credential
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        print('User signed in (facebook): ${userCredential.user?.email}');
        print('UID (facebook): ${userCredential.user?.uid}');

        await _authRepository.loginWithGoogleAndFacebook(
            userCredential.user?.email, userCredential.user?.uid);
      } else {
        String errorMessage = 'Failed to get Facebook access token.';

        throw errorMessage;
      }
    } else {
      String errorMessage = loginResult.status.name;

      throw errorMessage;
    }
  }
}
