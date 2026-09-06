import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4F46E5);      // Indigo primary
  static const Color primaryLight = Color(0xFFEEF2FF); // Soft tint indigo for chat bubbles
  static const Color background = Color(0xFFF8FAFC);   // Soft lavender-grey background
  static const Color surface = Color(0xFFFFFFFF);      // White cards/containers
  static const Color textDark = Color(0xFF0F172A);     // Deep charcoal for high contrast text
  static const Color textMuted = Color(0xFF64748B);    // Slate grey for captions and body
  static const Color border = Color(0xFFE2E8F0);       // Light border lines
  static const Color accent = Color(0xFF0EA5E9);       // Sky blue/cyan accent
  static const Color activeGreen = Color(0xFF10B981);  // Online indicator green
  static const Color activeRed = Color(0xFFEF4444);    // Hangup/missed call red
  static const Color shadow = Color(0x0A0F172A);       // Very subtle shadow color
  static const Color callingBg = Color(0xFF1E293B);    // Semi-dark slate for call background
}
