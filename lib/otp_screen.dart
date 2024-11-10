import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cng/detailed_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  OtpScreen({Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  Timer? _timer;
  int _start = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isEmpty) {
      _focusPreviousField(index);
    } else if (value.length == 1) {
      _focusNextField(index);
    }
  }

  void _focusNextField(int index) {
    switch (index) {
      case 0:
        _focusNode2.requestFocus();
        break;
      case 1:
        _focusNode3.requestFocus();
        break;
      case 2:
        _focusNode4.requestFocus();
        break;
      case 3:
        _focusNode4.unfocus();
        break;
    }
  }

  void _focusPreviousField(int index) {
    switch (index) {
      case 1:
        _focusNode1.requestFocus();
        break;
      case 2:
        _focusNode2.requestFocus();
        break;
      case 3:
        _focusNode3.requestFocus();
        break;
      case 0:
        _focusNode1.unfocus();
        break;
    }
  }

  void _verifyOTP() async {
    String smsCode = _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => detailed_screen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }

  }
  @override
  void dispose() {
    _timer?.cancel();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            _buildTopBar(),
            _buildOtpInputFields(),
            _buildVerifyButton(),
            _buildResendCountdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Container(
        height: 60,
        color: Colors.black,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SvgPicture.asset('assets/logo.svg', width: 30.8, height: 30.8),
            ),
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
    );
  }

  Widget _buildOtpInputFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 210, left: 26, right: 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Color(0xFFF4F4F4),
              ),
              child: TextField(
                controller: [_otpController1, _otpController2, _otpController3, _otpController4][index],
                focusNode: [_focusNode1, _focusNode2, _focusNode3, _focusNode4][index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(border: InputBorder.none, counterText: ''),
                onChanged: (value) => _onOtpChanged(value, index),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 360, left: 30, right: 30),
      child: GestureDetector(
        onTap: _verifyOTP,
        child: Container(
          height: 59,
          decoration: BoxDecoration(
            color: Color(0xFFE47B37),
            borderRadius: BorderRadius.circular(29.5),
          ),
          child: Center(
            child: Text(
              'Verify',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendCountdown() {
    return Positioned(
      top: 290,
      left: 30,
      right: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Resend OTP in ',
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
          ),
          Text(
            '00:${_start.toString().padLeft(2, '0')}',
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
