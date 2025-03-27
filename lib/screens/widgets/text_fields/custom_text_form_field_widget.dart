import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTexFormFiledWidget extends StatelessWidget {
  final TextEditingController? controller;

  final FormFieldValidator<String?>? validator;

  final String? text;

  final String? hintText;

  final bool isSuffixIconHave;

  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;

  const CustomTexFormFiledWidget({
    super.key,
    this.controller,
    this.text,
    this.hintText,
    this.validator,
    this.isSuffixIconHave = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text ?? "",
          style: TextStyle(fontSize: 16, color: AppColors.c101426, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          inputFormatters:
              keyboardType != TextInputType.number
                  ? null
                  : [
                    LengthLimitingTextInputFormatter(20),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                    NumericInputFormatter(),
                  ],
          textInputAction: textInputAction,
          style: TextStyle(color: AppColors.c101426, fontSize: 14.sp, fontWeight: FontWeight.w500),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: AppColors.c101426,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  controller?.clear();
                },
                child: SvgPicture.asset(AppIcons.clear),
              ),
            ),
            suffixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: hintText,
            labelStyle: TextStyle(
              color: AppColors.c101426,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            errorStyle: TextStyle(color: AppColors.cFF6345, fontSize: 16),
            contentPadding: EdgeInsets.only(left: 10.w, right: 20.w).w,
            hintStyle: TextStyle(
              color: AppColors.c878787,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.white,
            filled: false,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.c101426),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.c101426),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.c101426),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.c101426),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.c101426),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.c101426),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
          ),
        ),
      ],
    );
  }
}

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(" ", "");

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

      String formattedText = "";
      int digitCount = 0;
      for (int i = newText.length - 1; i >= 0; i--) {
        formattedText = newText[i] + formattedText;
        digitCount++;
        if (digitCount % 3 == 0 && i != 0) {
          formattedText = " $formattedText";
        }
      }

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(
          offset: formattedText.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
