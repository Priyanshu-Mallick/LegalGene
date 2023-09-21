import 'package:flutter/material.dart';
import 'package:legal_gene/Screens/splash_screen.dart';

import '../Services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.06,
        titleSpacing: 9,
        title: const Text(
          "Home Page",
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
        actions: [
          buildPopupMenuButton(context), // Add your trailing icon button here
        ],
        backgroundColor: Color(0xFFFCBB04),
        centerTitle: true,
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      color: const Color.fromRGBO(41, 32, 70, 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
      ),
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
        size: MediaQuery.of(context).size.height * 0.03,
      ),
      onSelected: (String result) {
        if (result == 'logout') {
          // Handle the logout action here
          AuthService.signOut();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
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
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

