import 'package:flutter/material.dart';

import '../Widgets/bottom_navigation.dart';

class KyrScreen extends StatefulWidget {
  const KyrScreen({super.key});

  @override
  State<KyrScreen> createState() => _KyrScreenState();
}

class _KyrScreenState extends State<KyrScreen> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFCBB04),
        title: Text("Know your rights"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to execute on button press
        },
        elevation: 10,
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.call),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: _selectedIndex),
    );
  }
}
