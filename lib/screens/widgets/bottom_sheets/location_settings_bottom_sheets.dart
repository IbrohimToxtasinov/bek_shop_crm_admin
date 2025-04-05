import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_outlined_button.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSettingsBottomSheet extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final String subTitle;
  final String icon;
  final String buttonText;

  const LocationSettingsBottomSheet({
    super.key,
    this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.cFFC34A, shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: SvgPicture.asset(
                  icon,
                  height: 32.h,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: 20.h),
          MainActionButton(label: buttonText, onTap: () => onTap!.call()),
          SizedBox(height: 10.h),
          MainActionOutlinedButton(label: "cancel".tr(), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
