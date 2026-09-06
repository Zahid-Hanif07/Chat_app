import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/core/theme/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? align;
  final double? height;
  final TextStyle? style;

  const CustomText(
    this.text, {
    super.key,
    this.size = 14,
    this.color = AppColors.textDark,
    this.weight = FontWeight.normal,
    this.maxLines,
    this.overflow,
    this.align,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.inter(
        textStyle: style ?? TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          height: height,
        ),
      ),
    );
  }
}
