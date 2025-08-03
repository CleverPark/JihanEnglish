import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // 제목용 - 둥근 느낌의 폰트
  static TextStyle heading1 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle heading2 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  // 게임 내 텍스트 (태블릿 최적화)
  static TextStyle gameText = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 48.sp,
    fontWeight: FontWeight.w500,
  );

  // 버튼 텍스트
  static TextStyle button = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  // 일반 텍스트
  static TextStyle body1 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle body2 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
}