import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_outlined_button.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteDialog extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DeleteDialog({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.sp, color: AppColors.c101828),
        ),
        SizedBox(height: 32.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: MainActionButton(onTap: () => Navigator.pop(context), label: 'no'.tr()),
            ),
            SizedBox(width: 20.w),
            Expanded(flex: 1, child: MainActionOutlinedButton(onTap: onTap, label: 'yes'.tr())),
          ],
        ),
      ],
    );
  }
}
