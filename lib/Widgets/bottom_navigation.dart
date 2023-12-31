import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legal_gene/Screens/kyr_screen.dart';
import 'package:legal_gene/Screens/progress_screen.dart';
import 'package:legal_gene/Screens/user_profile.dart';

import '../Screens/home_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int initialIndex; // Add this variable

  BottomNavigationBarWidget({required this.initialIndex}); // Provide a default value

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState(initialIndex: initialIndex);
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex=0; // Add this variable
  // Constructor
  _BottomNavigationBarWidgetState({required int initialIndex}) {
    _selectedIndex = initialIndex;
  }
  // List of screens to navigate to based on the index
  final List<Widget> _screens = [
    HomeScreen(),
    CaseProgress(),
    KyrScreen(),
    UserProfile(email: "", userProfilePic: "", userName: ""),
  ];

  // Function to change the screen based on the selected index
  void _changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _screens[index],
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from right
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFFFCBB04),
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      elevation: 30,
      height: MediaQuery.of(context).size.height*0.07, // Increased the height to accommodate the text
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildNavigationItem(CupertinoIcons.home, 'Home', 0),
          buildNavigationItem(CupertinoIcons.calendar, 'Progress', 1),
          buildNavigationItem(CupertinoIcons.cart, 'KYR', 2),
          buildNavigationItem(CupertinoIcons.chat_bubble, 'Profile', 3),
        ],
      ),
    );
  }

  Widget buildNavigationItem(IconData iconData, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        _changeScreen(index); // Call the function to change the screen
        print(index);
        print(_selectedIndex);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30, // Set the size of the touchable area
            height: 30, // Set the size of the touchable area
            child: Icon(
              iconData,
              color: isSelected ? Colors.black : Colors.brown,
            ),
          ),
          Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
        ],
      ),
    );
  }
}