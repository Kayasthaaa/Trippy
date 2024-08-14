import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippy/src/constant/colors.dart';

Widget btnText(String label) {
  return Text(
    label,
    style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white),
  );
}

Widget resText(String label) {
  return Text(
    label,
    style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600, fontSize: 13, color: AppColor.appColor),
  );
}
