import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainActionButton extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final Color? colorText;
  final Color? colorButton;
  final void Function()? onTap;
  final bool enabled;

  const MainActionButton({
    super.key,
    this.label,
    this.labelWidget,
    this.onTap,
    this.colorText,
    this.colorButton,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: enabled ? onTap : null,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: enabled ? AppColors.cFFC34A : AppColors.c8F9BB3,
          borderRadius: BorderRadius.circular(16).r,
        ),
        child: Center(
          child:
              labelWidget ??
              Text(
                label ?? "",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.c101426,
                ),
              ),
        ),
      ),
    );
  }
}
