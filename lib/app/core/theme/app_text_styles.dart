import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // 제목용 - 둥근 느낌의 폰트
  static TextStyle get heading1 => GoogleFonts.notoSans(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle get heading2 => GoogleFonts.notoSans(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  // 게임 내 텍스트 (태블릿 최적화)
  static TextStyle get gameText => GoogleFonts.notoSans(
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
  );

  // 버튼 텍스트
  static TextStyle get button => GoogleFonts.notoSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  // 일반 텍스트
  static TextStyle get body1 => GoogleFonts.notoSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get body2 => GoogleFonts.notoSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
}