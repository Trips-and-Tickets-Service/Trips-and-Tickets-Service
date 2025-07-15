import 'package:flutter/material.dart';
import '../providers/provider.dart';

TextStyle titleStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 23,
  fontWeight: FontWeight.w800,
  color: Colors.white
);

TextStyle titleStyleBlack = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 23,
  fontWeight: FontWeight.w800,
  color: Colors.black
);

TextStyle titleStyleBigBlack = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 26,
  fontWeight: FontWeight.w800,
  color: Colors.black
);

TextStyle titleStyleBigWhite = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 26,
  fontWeight: FontWeight.w800,
  color: Colors.white
);


TextStyle buttonTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: blackColor,
  letterSpacing: 1.0,
);

TextStyle buttonTextStyleInvis = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  letterSpacing: 1.0,
);

TextStyle buttonTextStyleBig = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 17,
  fontWeight: FontWeight.w600,
  color: Color.fromARGB(255, 58, 58, 58),
  letterSpacing: 0.9,
);

TextStyle basicTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Colors.white
);

TextStyle basicTextStyleBlack = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

TextStyle errorTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Color.fromARGB(255, 249, 61, 61)
);

TextStyle basicTextStyleInvis = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Colors.black
);

TextStyle buttonTextStyleMin = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: Color.fromARGB(255, 58, 58, 58),
  letterSpacing: 1.0,
);

TextStyle buttonTextStyleMedium = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: blackColor,
  letterSpacing: 1.0,
);

TextStyle buttonTextStyleMediumWhite = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  letterSpacing: 1.0,
);


TextStyle buttonTextStyleMediumLogOut = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: logOutColor,
  letterSpacing: 1.0,
);

TextStyle basicTextStyleMin = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Colors.white
);

TextStyle basicTextStyleBoldBlack = const TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.black
);

TextStyle neonTextStyle = const TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(blurRadius: 20.0, color: Colors.blue, offset: Offset(0, 0)),
    Shadow(blurRadius: 20.0, color: Colors.blue, offset: Offset(0, 0)),
    Shadow(blurRadius: 30.0, color: Colors.lightBlue, offset: Offset(0, 0)),
  ],
);

Color buttonColorW = Colors.white;

Color buttonColorInvis = Color.fromARGB(20, 255, 255, 255);

Color whiteColor = Colors.white;

Color dropdownColor = Color.fromARGB(255, 161, 127, 213);

Color invisColor = Color.fromARGB(0, 0, 0, 0);

Color pinkColor = Color.fromARGB(255, 236, 96, 163);

Color fieldProfileColorInvis = Color.fromARGB(40, 255, 255, 255);

Color logOutColor = Color.fromARGB(255, 255, 139, 139);

Color blackColor = Color.fromARGB(255, 28, 34, 43);

class NeonBorderPainter extends CustomPainter {
  final Color glowColor;
  final double glowRadius;

  NeonBorderPainter({this.glowColor = Colors.blue, this.glowRadius = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = glowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final radius = Radius.circular(20);
    
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}