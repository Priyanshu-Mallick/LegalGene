import 'package:flutter/material.dart';
import 'package:legal_gene/Screens/user_registration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();

    // Simulate the animation completion after 3 seconds
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _animationComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background color
          Container(
            color: Colors.black,
          ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Image.asset(
          //     'assets/back.jpg',
          //     fit: BoxFit.cover,
          //     color: Colors.black.withOpacity(0.5), // Adjust the opacity to blend with the black background
          //     colorBlendMode: BlendMode.darken, // Blend mode to achieve the desired effect
          //   ),
          // ),

          // Background GIF
          // Background GIF
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Adjust this value to move the GIF up or down
            left: 0,
            right: 0,
            child: !_animationComplete ? Image.asset(
              'assets/splash.gif',
            ) : Image.asset('assets/logo.png'),
          ),
          // Display the button if animation is complete
          // Display the button if animation is complete
          if (_animationComplete)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.32,
              right: MediaQuery.of(context).size.width * 0.32,
              bottom: MediaQuery.of(context).size.height * 0.13,
              child: Center(
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(begin: 1, end: 0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, value * MediaQuery.of(context).size.height),
                      child: child,
                    );
                  },
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const UserLogin(), // Assuming UserRegistration is the registration screen
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCBB04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 8, // Remove default elevation
                        shadowColor: const Color(0xFFFFD368),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Register'),
                          SizedBox(width: 3.0), // Adjust the spacing between text and icon
                          Icon(Icons.login), // Add your login icon here
                        ],
                      ),
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
