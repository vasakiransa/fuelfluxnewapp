import 'dart:async';
import 'package:cng/access_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class detailed_screen extends StatefulWidget {
  @override
  State<detailed_screen> createState() => _SplashState();
}

TextEditingController namec = TextEditingController();
TextEditingController emailc = TextEditingController();
TextEditingController passwordc = TextEditingController();

class _SplashState extends State<detailed_screen> {
  void _saveDetailsToFirestore() async {
    String name = namec.text.trim();
    String email = emailc.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields'),
        ),
      );
      return;
    }

    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.add({
        'name': name,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details saved successfully!'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => access_screen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save details: $e'),
        ),
      );
    }
  }

  void _validateAndNavigate() {
    String name = namec.text.trim();
    String email = emailc.text.trim();
    String password = passwordc.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields'),
        ),
      );
    } else {
      _saveDetailsToFirestore();
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF000000),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF000000),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 10, left: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: SizedBox(
                                        width: 30.8,
                                        height: 30.8,
                                        child: SvgPicture.asset(
                                          'assets/logo.svg',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'FuelFlux',
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          letterSpacing: 0.4,
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
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(33, 0, 33, 9),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Details',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              height: 1.2,
                              letterSpacing: 0.2,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name
                            Text("Full Name"),
                            TextFormField(
                              controller: namec,
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 12),

                            // Email Address
                            Text("Email Address"),
                            TextFormField(
                              controller: emailc,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 12),

                            // Password
                            Text("Password"),
                            TextFormField(
                              controller: passwordc,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 25),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 325,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _validateAndNavigate,
                              child: Text(
                                'Continue',
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF32D4A8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
