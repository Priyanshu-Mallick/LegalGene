import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Services/auth_services.dart';
import '../main.dart';
import 'home_screen.dart';

class UserProfile extends StatefulWidget {
  final String email;
  final String userProfilePic;
  final String userName;

  const UserProfile({
    required this.email,
    required this.userProfilePic,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin{
  String email = '';
  String userProfilePic = '';
  String userName = '';
  String phoneNumber = '';
  String selectedAge = '';
  String selectedSex = '';
  String selectedBlood = '';
  // late bool isDarkMode;
  late List<String> choices = [];
  TextEditingController _phoneNumberController = TextEditingController();
  // File? _image;
  late AuthService authService;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserData();
    _phoneNumberController = TextEditingController();
    authService = AuthService();
    email = widget.email;
    userProfilePic = widget.userProfilePic;
    userName = widget.userName;
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        setState(() {
          // Assign the retrieved data to the corresponding variables
          // Update the variables you use here based on the actual field names in Firestore
          userProfilePic = userData?['profilePictureUrl'] ?? '';
          email = userData?['email'] ?? '';
          userName = userData?['fullName'] ?? '';
          _phoneNumberController.text = userData?['phoneNumber'] ?? '';
          selectedAge = userData?['age'] ?? '';
          selectedSex = userData?['sex'] ?? '';
          selectedBlood = userData?['bloodGroup'] ?? '';
          // Add other fields if needed
        });
      }
    }
  }

  void CheckPhoneNumber(String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      final userSnapshot = await userRef.get();

      // if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      final savedPhoneNumber = userData?['phoneNumber'] ?? '';

      bool isRegistered = savedPhoneNumber == phoneNumber;

      if (!isRegistered) {
        // Phone number is not registered, send OTP and proceed to OTP verification
        String verificationId = await AuthService().sendOTPToPhone(phoneNumber);
        // await AuthService().showVerifyDialog(userName, email, phoneNumber, "", verificationId, context, userProfilePic, selectedAge, selectedSex, selectedBlood, 1);
      } else {
        // Phone number is registered, save user data and navigate to HomeScreen
        AuthService().SaveUserData(
          email,
          userProfilePic,
          userName,
          phoneNumber,
          selectedAge,
          selectedSex,
          selectedBlood,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
      // }
    }
  }


  Future _getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      if (img != null) {
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
        // Upload image to Firebase Cloud Storage
        String imageName = DateTime.now().millisecondsSinceEpoch.toString(); // Generating a unique name for the image
        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(imageName);

        firebase_storage.UploadTask uploadTask = ref.putFile(img);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL from the uploaded image
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          userProfilePic = imageUrl; // Update the userProfilePic variable
        });
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }


  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }


  void openImageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.transparent, // Set the background color to transparent
      builder: (BuildContext context) {
        return Stack(
          children: [
            // The blurred content of the background page
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the sigma values for the blur effect
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // The bottom sheet content
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Image Source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Send the image
                      _getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.camera,
                      size: 24,
                    ),
                    label: const Text('Camera'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Send the image
                      _getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.photo),
                    label: const Text('Gallery'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChoiceBottomSheet(BuildContext context, int c, String ctext) async {
    dynamic result;
    if(c == 1) {
      result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                    color: Color(0xFFFCBB04).withOpacity(0.5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: Color(0xFFFCBB04),
                        width: 4)
                ),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CupertinoPicker(

                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedAge = choices[index];
                      });
                    },
                    children: choices.map((choice) {
                      return Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFFCBB04), width:2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: Center(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(ctext, style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
                      )),
                    ),
                  )
              )
            ],
          );
        },
      );
    }
    else if(c == 2)
    {
      result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                    color: Color(0xFFFCBB04).withOpacity(0.5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: Color(0xFFFCBB04),
                        width: 4)
                ),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CupertinoPicker(

                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedSex = choices[index];
                      });
                    },
                    children: choices.map((choice) {
                      return Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFFCBB04), width:2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: Center(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(ctext, style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
                      )),
                    ),
                  )
              )
            ],
          );
        },
      );
    }
    else
    {
      result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                    color: Color(0xFFFCBB04).withOpacity(0.5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: Color(0xFFFCBB04),
                        width: 4)
                ),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CupertinoPicker(

                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedBlood = choices[index];
                      });
                    },
                    children: choices.map((choice) {
                      return Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFFCBB04), width:2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: Center(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(ctext, style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
                      )),
                    ),
                  )
              )
            ],
          );
        },
      );
    }
    if (result != null) {
      if(c == 1) {
        setState(() {
          selectedAge = result;
        });
      }
      else if(c == 2) {
        setState(() {
          selectedSex = result;
        });
      }
      else if(c == 3) {
        setState(() {
          selectedBlood = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildContent(context, 'You are a UP!'),
            _buildContent(context, 'You are a Lawer!'),
          ],
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(mq.height*0.055), // Adjust the height as needed
          child: AppBar(
            backgroundColor: Color(0xFFFCBB04),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'You are a UP!',
                    style: GoogleFonts.montserratTextTheme().subtitle1?.copyWith(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'You are a Lawer!',
                    style: GoogleFonts.montserratTextTheme().subtitle1?.copyWith(fontSize: 16),
                  ),
                ),
              ],
              indicator: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String tabName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      padding: EdgeInsets.only(top: mq.height*0.05, bottom: mq.height*0.02, right: mq.width*0.02, left: mq.width*0.02),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            children: [
              SizedBox(
                width: mq.width*0.3,
                height: mq.height*0.141,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: userProfilePic.isNotEmpty
                      ? Image.network(
                    userProfilePic,
                    fit: BoxFit.cover,
                  )
                      : Transform.scale(
                    scale: 7.0, // Adjust this value to increase or decrease the icon size
                    child: const Icon(CupertinoIcons.person_crop_circle_fill, color: Color(0xFFFCBB04),),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 19,
                  child: IconButton(
                    onPressed: () => openImageBottomSheet(),
                    color: Colors.black,
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: mq.height*0.02,
                      color: Color(0xFFFCBB04),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height*0.015),
          Column(
            children: [
              SizedBox(height: mq.height*0.01),
              TextField(
                readOnly: false,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: mq.height*0.02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFFFCBB04),
                    ),
                  ),
                  labelText: "Email-Id",
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCBB04),
                  ),
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  prefixIconColor: Color(0xFFFCBB04),
                ),
                controller: TextEditingController(text: email),
              ),
              SizedBox(height: mq.height*0.02),
              TextField(
                readOnly: false,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: mq.height*0.02),
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
                  labelText: "Full Name",
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCBB04),
                  ),
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  prefixIconColor: Color(0xFFFCBB04),
                ),
                controller: TextEditingController(text: userName),
              ),
              SizedBox(height: mq.height*0.02),
              TextField(
                readOnly: false,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: mq.height*0.02),
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
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCBB04),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                  prefixIconColor: Color(0xFFFCBB04),
                ),
                controller: _phoneNumberController, // Use the _phoneNumberController here
              ),
              SizedBox(height: mq.height*0.02),
              TextField(
                readOnly: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: mq.height*0.02),
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
                  labelText: 'Age',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCBB04),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  prefixIconColor: Color(0xFFFCBB04),
                ),
                controller: TextEditingController(text: selectedAge),
                onTap: () {
                  choices.clear();
                  for (int i = 1; i <= 120; i++) {
                    choices.add(i.toString());
                  }
                  _showChoiceBottomSheet(context, 1, "Select Age");
                },
              ),
              SizedBox(height: mq.height*0.02),
              TextField(
                readOnly: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: mq.height*0.02),
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
                  labelText: 'Sex',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCBB04),
                  ),
                  prefixIcon: const Icon(Icons.transgender_outlined),
                  prefixIconColor: Color(0xFFFCBB04),
                ),
                controller: TextEditingController(text: selectedSex),
                onTap: () {
                  selectedSex = '';
                  choices.clear();
                  choices = ["Male", "Female", "Others"];
                  _showChoiceBottomSheet(context, 2, "Select Sex");
                },
              ),

              SizedBox(height: mq.height*0.02),
              TextField(
                readOnly: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: mq.height*0.02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFFFCBB04),
                    ),
                  ),
                  labelText: 'Blood Group',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCBB04),
                  ),
                  prefixIcon: const Icon(Icons.water_drop),
                  prefixIconColor: Color(0xFFFCBB04),
                ),
                controller: TextEditingController(text: selectedBlood),
                onTap: () {
                  selectedBlood = '';
                  choices.clear();
                  choices = ["A+", "B+", "AB+", "O+", "A-", "B-", "AB-", "O-"];
                  _showChoiceBottomSheet(context, 3, "Select Blood Group");
                },
              ),
              SizedBox(height: mq.height*0.05),
              SizedBox(
                width: double.infinity,
                height: mq.height*0.055,
                child: ElevatedButton(
                  onPressed: () {
                    CheckPhoneNumber(_phoneNumberController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFCBB04),
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Save Profile",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: mq.height*0.02),
              // const Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Nirogh", style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 14,
              //       color: Colors.black,
              //     )),
              //     Text("The result you can Trust!", style: TextStyle(
              //       fontStyle: FontStyle.italic,
              //       fontSize: 13,
              //       color: Colors.black,
              //     )),
              //
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}
