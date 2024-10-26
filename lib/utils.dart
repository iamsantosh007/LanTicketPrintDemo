import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Utils{
  static showFlasbar(String message, BuildContext context) {
    Flushbar(
      animationDuration: const Duration(milliseconds: 3000),
      padding: const EdgeInsets.all(20),
      backgroundColor:
          const Color.fromARGB(255, 63, 84, 104), // Dark gray background
      icon: const Icon(
        Icons.warning_amber_rounded,
        size: 28.0,
        color: Color(0xFFFFC107), // Amber warning icon
      ),
      leftBarIndicatorColor: const Color(0xFF1976D2), // Blue left indicator
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFE3F2FD), // Light blue message text
          fontWeight: FontWeight.w700,
        ),
      ),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.all(10),
    ).show(context);
  }

}