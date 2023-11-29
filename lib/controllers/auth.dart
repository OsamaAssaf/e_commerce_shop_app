import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  String? verificationIdReceived;

  void changeUserState(User? newUser) {
    user = newUser;
    notifyListeners();
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.i.login();

      if (result.status == LoginStatus.success) {
        final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential? userCredential = await _auth.signInWithCredential(facebookAuthCredential);
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'imageUrl': userCredential.additionalUserInfo!.profile!['picture']['data']['url'],
          'email': userCredential.additionalUserInfo!.profile!['email'],
          'name': userCredential.additionalUserInfo!.profile!['name']
        });
      } else {
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text(e.message!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.blue[900]),
                  )),
            ],
          ),
        );
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential? userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'imageUrl': userCredential.additionalUserInfo!.profile!['picture'],
        'email': userCredential.additionalUserInfo!.profile!['email'],
        'name': userCredential.additionalUserInfo!.profile!['name']
      });
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text(e.message!),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.blue[900]),
                        )),
                  ],
                ));
      }
    }
  }

  Future<void> emailAndPassword(String email, String password, bool isReg) async {
    try {
      if (isReg) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      throw e.code;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkEmailVerified() async {
    await user!.reload();
    if (user!.emailVerified) {
      return;
    } else {}
  }

  Future<void> phoneAuth(String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text(e.message!),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                  ],
                ));
      },
      codeSent: (String verificationId, int? resendToken) async {
        verificationIdReceived = verificationId;
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyCode(String smsCode) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verificationIdReceived!, smsCode: smsCode);

    await _auth.signInWithCredential(credential);
  }

  logOut() async {
    await _auth.signOut();
  }
}
