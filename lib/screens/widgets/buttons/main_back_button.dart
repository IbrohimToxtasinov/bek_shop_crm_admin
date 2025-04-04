import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainBackButton extends StatelessWidget {
  final bool isClose;
  final Color? color;
  final IconData? icon;
  final void Function()? onTap;

  const MainBackButton({super.key, this.isClose = false, this.color, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: 35.h,
        width: 35.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? AppColors.cFFC34A),
        child: Icon(icon ?? Icons.arrow_back, size: 18.w, color: Colors.black),
      ),
    );
  }
}
