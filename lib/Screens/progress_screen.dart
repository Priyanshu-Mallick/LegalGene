import 'package:flutter/material.dart';

import '../Widgets/bottom_navigation.dart';

class CaseProgress extends StatefulWidget {
  const CaseProgress({super.key});

  @override
  State<CaseProgress> createState() => _CaseProgressState();
}

class _CaseProgressState extends State<CaseProgress> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFCBB04),
        title: Text("Check Case Progress"),
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
