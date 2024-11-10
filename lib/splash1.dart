import 'dart:async';
import 'package:cng/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
class Splash1 extends StatefulWidget {
  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      // Perform any initial logic if necessary
    });
  }
  void _savePhoneNumber(String phoneNumber) async {
  try {
    await _firestore.collection('users').add({
      'phone_number': phoneNumber,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Phone number saved to Firestore');
  } catch (e) {
    print('Error saving phone number: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save phone number")),
    );
  }
}


  void _validateAndNavigate(BuildContext context) {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your mobile number')),
      );
      return;
    } else if (!RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    String formattedNumber = '+91$phoneNumber';
     _savePhoneNumber(formattedNumber);
    _auth.verifyPhoneNumber(
      phoneNumber: formattedNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Phone number verified automatically!")),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
              phoneNumber: formattedNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Phone Number')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                children: [
                  SvgPicture.asset('assets/logo.svg', width: 30, height: 30),
                  SizedBox(width: 10),
                  Text(
                    'FuelFlux',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
            Text(
              'Find nearby CNG stations with real-time wait times.',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Enter your Mobile Number',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              'We promise to never spam or share your personal information',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixText: '+91 ',
                labelText: 'Phone Number',
                hintText: 'Enter 10-digit mobile number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _validateAndNavigate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE47B37),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Send OTP',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
