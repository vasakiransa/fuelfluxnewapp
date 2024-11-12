/// Imports the 'dart:async' library, which provides the Dart asynchronous programming model.
import 'dart:async';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cng/car_registration_screen.dart';
import 'package:cng/splash1.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:cng/page4.dart' as page4;
import 'package:cng/page1.dart' as page1;
import 'package:cng/page2.dart' as page2;

import 'package:cng/page3.dart' as page3;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Inside your booking screen class, add this method to save booking data
Future<void> saveBookingData({
  required String userId,
  required String serviceType,
  required String vehicleNumber,
  required String quantity,
  required String bookingDate,
  required String bookingTime,
  required String pumpName,
  required String location,
  String status = 'pending', // Added status parameter with default value
}) async {
  try {
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': userId,
      'serviceType': serviceType,
      'vehicleNumber': vehicleNumber,
      'quantity': quantity,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'pumpName': pumpName,
      'location': location,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error saving booking: $e');
    rethrow;
  }
}

class booking_screen extends StatefulWidget {
  final String vehicle_num;

  // receive data from the FirstScreen as a parameter
  booking_screen({Key? key, required this.vehicle_num}) : super(key: key);
  @override
  State<booking_screen> createState() => _SplashState();
}

class _SplashState extends State<booking_screen> {
  final _pageController = PageController(initialPage: 1);

  /// Controlle r to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const page1.Page1(),
      const page11(),
      const page3.Page3(),
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.black,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: Colors.black87,
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              itemLabelStyle: const TextStyle(fontSize: 10),
              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem:
                      Icon(Icons.send_outlined, color: Colors.blueGrey),
                  activeItem: Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.map_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 4',
                ),
              ],
              onTap: (index) {
                // log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
    );
  }
}

String selectedVehicle = 'Honda Pulsar';

final List<Map<String, String>> vehicles = [
  {'name': 'Honda Pulsar', 'image': 'assets/pulser.png'},
  {'name': 'Yamaha R15', 'image': 'assets/r15.png'},
  {'name': 'Suzuki Gixxer', 'image': 'assets/gixxer.png'},
  {'name': 'Kawasaki Ninja', 'image': 'assets/ninja.png'},
];

class page11 extends StatefulWidget {
  const page11({Key? key}) : super(key: key);

  @override
  State<page11> createState() => _page11State();
}

DateTime selectedDate = DateTime.now();

String _selectedTime = "18:35"; // This acts as the "controller" for the text
String _formattedDate = DateFormat('d MMMM').format(DateTime.now());

class _page11State extends State<page11> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xffF69454),
            hintColor: Color(0xffF69454),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xffF69454),
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _formattedDate = DateFormat('d MMMM')
            .format(selectedDate); // Update the formatted date
      });
    }
  }

  int _selectedIndex = 0;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime =
            pickedTime.format(context); // Update the text with selected time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // ... (previous code remains unchanged)
            Padding(
              padding: const EdgeInsets.only(
                  top: 800, bottom: 110, left: 30, right: 30),
              child: GestureDetector(
                onTap: () async {
                  // Firebase booking logic added here
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: Row(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFE47B37)),
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Booking in Progress",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            "Please wait while we process your booking.",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    );

                    await saveBookingData(
                        userId: user.uid,
                        pumpName: 'Indian Oil Petroleum',
                        location: '58-12 Queens Blvd, Suite2 Queens, NY 11377',
                        bookingTime: DateTime.now().toString(),
                        status: 'pending',
                        serviceType: _selectedIndex != -1
                            ? [
                                'Petrol',
                                'Diesel',
                                'Gas',
                                'Electrical'
                              ][_selectedIndex]
                            : '',
                        vehicleNumber: vehicle,
                        quantity: selectedVehicle,
                        bookingDate: _formattedDate);

                    Navigator.of(context).pop(); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page11()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Not Authenticated"),
                          content: Text("Please log in to continue."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 59,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE47B37),
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Book Now',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              height: 1.2,
                              letterSpacing: -0.2,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
