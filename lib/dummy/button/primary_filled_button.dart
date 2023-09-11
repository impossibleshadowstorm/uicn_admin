import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrimaryFilledButton extends StatefulWidget {
  final double width;
  final String buttonText;

  const PrimaryFilledButton({
    super.key,
    required this.width,
    required this.buttonText,
  });

  @override
  State<PrimaryFilledButton> createState() => _PrimaryFilledButtonState();
}

class _PrimaryFilledButtonState extends State<PrimaryFilledButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: widget.width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF941A49),
            Color(0xFF941A49),
            Color(0xFFEF578A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          widget.buttonText,
          style: GoogleFonts.heebo(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
