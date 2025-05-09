import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showTrailing = false,
    this.centerTitle = true,
    this.trailing,
  });

  final String title;
  final bool showTrailing;
  final bool centerTitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      iconTheme: IconThemeData(size: 20.w),
      elevation: 0,
      title: Text(title),
      titleTextStyle: TextStyle(
        color: AppColors.c101426,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
      actions: [if (showTrailing) Padding(padding: EdgeInsets.only(right: 8.0.w), child: trailing)],
      centerTitle: centerTitle,
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size(double.infinity.w, 56.h);
}
