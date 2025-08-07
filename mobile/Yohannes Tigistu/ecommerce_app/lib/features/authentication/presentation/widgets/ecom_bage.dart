import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFF3F51F3); // Example primary color

Card ecom(double textSize) {
  return Card(
    shadowColor: Colors.black54,
    elevation: 5.0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(textSize / 4),
      side: BorderSide(color: Color.fromARGB(135, 63, 81, 243), width: 2.0),
    ),

    child: Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Prevents Row from expanding
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ECOM',
            style: TextStyle(
              color: primaryColor,
              fontFamily: 'CaveatBrush',
              fontSize: textSize,
              height: (textSize + 10) / textSize,
              fontWeight: FontWeight.bold,
              letterSpacing: textSize / 20,
            ),
          ),
        ],
      ),
    ),
  );
}
