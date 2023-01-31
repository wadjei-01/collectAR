import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle getTextStlye(fontsize, fontweight, color, height,
    {TextDecoration? textDecoration}) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: fontsize,
      fontWeight: fontweight,
      color: color,
      height: height,
      decoration: textDecoration ?? TextDecoration.none);
}

TextStyle getRegularStyleSmaller({color, height, fontsize}) {
  return getTextStlye(7.sp, FontWeight.w400, color, height);
}

TextStyle getRegularStyleSmall({color, height, fontsize}) {
  return getTextStlye(10.sp, FontWeight.w600, color, height);
}

TextStyle getRegularStyle({color, height, fontsize}) {
  return getTextStlye(11.sp, FontWeight.w400, color, height);
}

TextStyle getMediumSmaller({color, height, fontsize}) {
  return getTextStlye(12.sp, FontWeight.w400, color, height);
}

TextStyle getRegularSmallStrike(
    {color, height, fontsize, TextDecoration? textDecoration}) {
  return getTextStlye(13.sp, FontWeight.w400, color, height,
      textDecoration: textDecoration);
}

TextStyle getMedium({color, height, fontsize}) {
  return getTextStlye(14.sp, FontWeight.w400, color, height);
}

// Headers Style
TextStyle BoldHeaderstextStyle({color, fontSize}) {
  return TextStyle(
      fontFamily: 'Montserrat-Bold', fontSize: fontSize ?? 55.sp, color: color);
}

TextStyle MediumHeaderStyle({color, fontSize, overFlow}) {
  return TextStyle(
      fontFamily: 'Montserrat-SemiBold',
      fontSize: fontSize ?? 30.sp,
      color: color,
      overflow: overFlow);
}

TextStyle RegularHeaderStyle({fontSize, color, height}) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      height: height);
}

TextStyle SmallSizeHeaderStyle({color}) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 13.sp,
      color: color);
}

TextStyle otherStyle({color, fontsize, height}) {
  return TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: fontsize,
    color: color,
  );
}
