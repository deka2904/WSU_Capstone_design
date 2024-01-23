import 'package:flutter/material.dart';

/**텍스트 스타일 */
TextStyle textStyle(double size, Color color, FontWeight weight, double space) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: weight,
    letterSpacing: space,
  );
}
