import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var theight = MediaQuery.of(context).size.height;
    var twidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFFFCBB04),
            size: theight * 0.038314176,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color(0xFFFCBB04),
              size: theight * 00.038314176,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height:  theight,
        width: twidth,
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: twidth * 0.025445293),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, Priyanshu!",
              style: TextStyle(
                color: Color(0xFFFCBB04),
                fontSize: theight * 0.03192848,
              ),

            ),
            SizedBox(height: theight * 0.00510677808710166742965059189544),
            Row(
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.white,
                ),
                SizedBox(width: twidth * 0.012722646),
                Text(
                  "SIT",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: theight * 0.025542784,
                  ),
                ),
              ],
            ),
            SizedBox(height: theight * 0.022988506),
            TextField(
              cursorColor: Color(0xFFFCBB04),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xFFFCBB04),
                  ),
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Color(0xFFFCBB04),
              ),
            ),
            SizedBox(height: theight * 0.025542784),
            Text(
              "Categories:",
              style: TextStyle(
                color: Colors.white,
                fontSize: theight * 0.03192848,
              ),
            ),
            SizedBox(height: theight * 0.019157088),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.transparent,
                    shadowColor: Colors.white,
                    child: Container(
                      height: theight * 0.140485313,
                      width: twidth * 0.279898219,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFCBB04),
                            Colors.black,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.book, color: Colors.white, size: 40,),
                          Text(
                            "Legal Resources",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                ),
                Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.transparent,
                    shadowColor: Colors.white,
                    child: Container(
                      height: theight * 0.140485313,
                      width: twidth * 0.279898219,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFCBB04),
                            Colors.black,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.book, color: Colors.white, size: 40,),
                          Text(
                            "Pro Lawyer",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                ),
                Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.transparent,
                    shadowColor: Colors.white,
                    child: Container(
                      height: theight * 0.140485313,
                      width: twidth * 0.279898219,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFCBB04),
                            Colors.black,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.book, color: Colors.white, size: 40,),
                          Text(
                            "Vocational Training",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height: theight * 0.025542784),
            Text(
              "Popular:",
              style: TextStyle(
                color: Colors.white,
                fontSize: theight * 0.03192848,
              ),
            ),
            SizedBox(height: theight * 0.019157088),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFCBB04), // Start color
                          Colors.black,      // End color
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    padding: EdgeInsets.symmetric(vertical: theight * 0.012771392),
                    child: ListTile(
                      leading: Icon(
                        Icons.book,
                        size: theight * 0.051085568,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Amendments",
                        style: TextStyle(
                          fontSize: theight * 0.03192848,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "hbasbjxbsjbkjbkxkjsjxkjskjxkjs kjkjnkxnjksxn",
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFCBB04),
                          size: theight * 0.051085568,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: theight * 0.022988506),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFCBB04), // Start color
                          Colors.black,      // End color
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    padding: EdgeInsets.symmetric(vertical: theight * 0.012771392),
                    child: ListTile(
                      leading: Icon(
                        Icons.book,
                        size: theight * 0.051085568,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Health Support",
                        style: TextStyle(
                          fontSize: theight * 0.03192848,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: const Text(
                        "hbasbjxbsjbkjbkxkjsjxkjskjxkjs kjkjnkxnjksxn",
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: const Color(0xFFFCBB04),
                          size: theight * 0.051085568,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: theight * 0.022988506),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFCBB04), // Start color
                          Colors.black,      // End color
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                    ),
                    padding: EdgeInsets.symmetric(vertical: theight * 0.012771392),
                    child: ListTile(
                      leading: Icon(
                        Icons.book,
                        size: theight * 0.051085568,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Case Study",
                        style: TextStyle(
                          fontSize: theight * 0.03192848,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "hbasbjxbsjbkjbkxkjsjxkjskjxkjs kjkjnkxnjksxn",
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFFCBB04),
                          size: theight * 0.051085568,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to execute on button press
        },
        elevation: 10,
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: _selectedIndex),
    );
  }
}