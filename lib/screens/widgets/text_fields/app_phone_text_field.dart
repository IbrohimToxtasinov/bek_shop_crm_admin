import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppPhoneTextField extends StatefulWidget {
  final FormFieldValidator<String?>? validator;
  final TextEditingController? phoneTextController;
  final String? prefixText;
  final Widget? suffixIcon;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function onChanged;

  const AppPhoneTextField({
    super.key,
    this.phoneTextController,
    this.prefixText,
    this.suffixIcon,
    this.enabled = true,
    this.focusNode,
    required this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.validator,
  });

  @override
  State<AppPhoneTextField> createState() => _AppPhoneTextFieldState();
}

class _AppPhoneTextFieldState extends State<AppPhoneTextField> {
  late MaskTextInputFormatter phoneMaskFormatter;

  @override
  void initState() {
    phoneMaskFormatter = MaskTextInputFormatter(
      mask: '+998 (##) ###-##-##',
      filter: {"#": RegExp(r'\d')},
    );
    super.initState();
  }

  @override
  void dispose() {
    phoneMaskFormatter.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "client_phone_number".tr(),
          style: TextStyle(fontSize: 16.sp, color: AppColors.c101426, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          enabled: widget.enabled,
          autofocus: false,
          cursorColor: AppColors.aravvaBlack,
          controller: widget.phoneTextController,
          inputFormatters: [phoneMaskFormatter],
          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
          focusNode: widget.focusNode,
          onChanged: (String value) {
            widget.onChanged(value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          style: TextStyle(color: AppColors.c101426, fontSize: 14.sp, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: "enter_client_phone_number".tr(),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            errorStyle: TextStyle(color: AppColors.cFF6345, fontSize: 16.sp),
            hintStyle: TextStyle(
              color: AppColors.c878787,
              fontSize: 14.sp,
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
