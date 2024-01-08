import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/core/constants/firebase_scopes.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDataSource {
  final FirebaseAuth firebaseAuth;

  const UserDataSource({required this.firebaseAuth});

  Future<UserCredential> doSignUp(Credential userCredential) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: userCredential.email, password: userCredential.password);
  }

  Future<GoogleSignInAccount?> doSignIn() async =>
      await GoogleSignIn(scopes: oauthScopes).signIn();

  Future<UserCredential> doSignInWithCredential(Credential userCredential) async =>
      await firebaseAuth.signInWithEmailAndPassword(email: userCredential.email, password: userCredential.password);
}
