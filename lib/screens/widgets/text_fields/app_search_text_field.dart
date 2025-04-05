import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSearchTextField extends StatefulWidget {
  final String? hint;

  final TextEditingController? controller;

  final TextInputAction? textInputAction;

  final Function(String)? onChanged;

  final void Function()? prefixTap;

  final FocusNode? focusNode;

  final Color color;

  @override
  State<AppSearchTextField> createState() => _AppSearchTextFieldState();

  const AppSearchTextField({
    this.hint,
    this.controller,
    this.textInputAction,
    super.key,
    this.onChanged,
    this.focusNode,
    this.prefixTap,
    this.color = AppColors.aravvaWhite,
  });
}

class _AppSearchTextFieldState extends State<AppSearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              height: 50.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: widget.color,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.search,
                    colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  Expanded(
                    child: TextFormField(
                      focusNode: widget.focusNode,
                      onChanged: widget.onChanged,
                      cursorColor: AppColors.c101828,
                      cursorHeight: 20.h,
                      cursorOpacityAnimates: true,
                      textInputAction: widget.textInputAction,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c101828,
                        fontSize: 16.sp,
                      ),
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.c878787,
                          fontSize: 16.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.prefixTap,
                    child: SvgPicture.asset(AppIcons.clear, width: 20.w, height: 20.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
