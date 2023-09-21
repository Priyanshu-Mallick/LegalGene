import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Services/auth_services.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  double _animationValue = 1.0; // Variable to control the animation

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    // _firestore = FirebaseFirestore.instance;
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    // Start the animation when the widget is created
    startAnimation();
  }

  // Function to start the animation
  void startAnimation() async {
    // Delay the animation for 500 milliseconds
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      _animationValue = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.6,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(.4),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, bottom: MediaQuery.of(context).size.height * 0.17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              tween: Tween<double>(begin: 1, end: _animationValue),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(
                                      0, value * MediaQuery.of(context).size.height),
                                  child: Opacity(
                                    opacity: 1 - value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                "Welcome to",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              tween: Tween<double>(begin: 1, end: _animationValue),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(
                                      0, value * MediaQuery.of(context).size.height),
                                  child: Opacity(
                                    opacity: 1 - value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                "LegalGene",
                                style: TextStyle(
                                  color: Color(0xFFFCBB04),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 1, end: _animationValue),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value * MediaQuery.of(context).size.height),
                        child: Opacity(
                          opacity: 1 - value,
                          child: child,
                        ),
                      );
                    },
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false, // Disable popping with back button
                              child: const Center(
                                child: SpinKitFadingCircle(
                                  color: Color(0xFFFCBB04),
                                  size: 50.0,
                                ),
                              ),
                            );
                          },
                        );
                        await AuthService().signInWithGoogle(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCBB04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 8, // Remove default elevation
                        shadowColor: const Color(0xFFFFD368),
                      ),
                      icon: Image.asset(
                        'assets/google.png',
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.height * 0.055,
                      ),
                      label: Text('Signin with Google'),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 1, end: _animationValue),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value * MediaQuery.of(context).size.height),
                        child: Opacity(
                          opacity: 1 - value,
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: Text("OR", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 850),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 1, end: _animationValue),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value * MediaQuery.of(context).size.height),
                        child: Opacity(
                          opacity: 1 - value,
                          child: child,
                        ),
                      );
                    },
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle Facebook login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCBB04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 8, // Remove default elevation
                        shadowColor: const Color(0xFFFFD368),
                      ),
                      icon: Image.asset(
                        'assets/facebook.png',
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.height * 0.03,
                      ),
                      label: Text('Signin with Facebook'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 1, end: _animationValue),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      value * MediaQuery.of(context).size.height,
                    ),
                    child: Opacity(
                      opacity: 1 - value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.05),
                  child: Text(
                    "By signing in, you agree to our Terms and Conditions",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
