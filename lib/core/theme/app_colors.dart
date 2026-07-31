import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF4F4F2);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF191919);
  static const textSecondary = Color(0xFF6B6B63);
  static const accent = Color(0xFFACFF79); // Parqie logo green
  static const accentText = Color(0xFF191919); // Parqie logo glyph black
  static const error = Color(0xFFC0392B);
  static const shadow = Color(0x1A000000);
  // Distinct blue used only for the user's current-location marker, kept
  // visually separate from the yellow accent used for location pins.
  static const userLocation = Color(0xFF4285F4);
}
