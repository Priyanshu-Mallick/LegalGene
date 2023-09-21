import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:legal_gene/Screens/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool isOTPSent = false; // Add this variable to track whether OTP has been sent
  FirebaseAuth auth = FirebaseAuth.instance; // Declare the auth variable outside the sendOTP method
  String? verificationId;
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Configure GoogleSignIn with the required scopes
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );

      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser != null) {
        // Obtain auth details from request
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        // Create a new credential for the user
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        // Finally, let's sign in
        final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

        // If the sign-in is successful, retrieve and pass user data to UpdateProfileScreen
        if (authResult.user != null) {
          final user = authResult.user!;
          AuthService.setLoggedIn(true);
          Navigator.pop(context);
          // Store user data in Firestore
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          CollectionReference userDataCollection = firestore.collection('user_data');

          await userDataCollection.doc(user.uid).set({
            'email': user.email ?? "",
            'userProfilePic': user.photoURL ?? "",
            'userName': user.displayName ?? "",
          });
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => UserProfile(
                email: user.email ?? "",
                userProfilePic: user.photoURL ?? "",
                userName: user.displayName ?? "",), // Assuming UserRegistration is the registration screen
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors that occur during sign-in
      print("Error during sign-in: $e");
    }
  }
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await setLoggedIn(false);
  }
  Future<String> sendOTPToPhone(String phoneNumber) async {

    Completer<String> completer = Completer<String>(); // Create a Completer

    String verificationID;
    await auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          verificationID = verificationId;
          Fluttertoast.showToast(
            msg: 'OTP sent successfully to phone number',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
          );
          completer.complete(verificationID);
        },
        codeAutoRetrievalTimeout: (verificationId){
          // verificationID = verificationId;
        },
        verificationFailed: (e){
          print("Failed to send code ${e.message}");
          Fluttertoast.showToast(
            msg: 'Unknown Error occurred while sending OTP',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
          );
          completer.completeError(e);
        }
    );
    return completer.future; // Return the future from the completer
  }

  Future<void> SaveUserData(String email, String userProfilePic, String userName, String phoneNumber, String selectedAge, String selectedSex, String selectedBlood) async {

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userData = {
          'profilePictureUrl': userProfilePic,
          'email' : email,
          'fullName': userName,
          'phoneNumber': phoneNumber,
          'age': selectedAge,
          'sex': selectedSex,
          'bloodGroup': selectedBlood,
        };
        final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
        if (await userRef.get().then((snapshot) => snapshot.exists)) {
          await userRef.update(userData);
        } else {
          await userRef.set(userData);
        }
        print('User data saved successfully');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

}