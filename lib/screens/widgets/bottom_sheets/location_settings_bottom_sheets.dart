import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_outlined_button.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.cFFC34A,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  icon,
                  height: 32,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          MainActionButton(label: buttonText, onTap: () => onTap!.call()),
          const SizedBox(height: 10),
          MainActionOutlinedButton(label: "cancel".tr(), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
