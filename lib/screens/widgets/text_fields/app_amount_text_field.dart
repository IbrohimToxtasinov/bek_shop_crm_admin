import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AppAmountTextFiled extends StatefulWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final String? text;
  final String? hintText;
  final bool isSuffixIconHave;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  const AppAmountTextFiled({
    super.key,
    this.controller,
    this.text,
    this.hintText,
    this.validator,
    this.isSuffixIconHave = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.number,
  });

  @override
  _AppAmountTextFiledState createState() => _AppAmountTextFiledState();
}

class _AppAmountTextFiledState extends State<AppAmountTextFiled> {
  final NumberFormat _numberFormat = NumberFormat('#,##0', 'uz_UZ');

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_formatInput);
  }

  void _formatInput() {
    final text = widget.controller?.text.replaceAll(' ', '') ?? '';
    if (text.isEmpty) return;

    final num? value = num.tryParse(text);
    if (value != null) {
      final formattedText = _numberFormat.format(value);
      widget.controller?.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.text ?? "",
          style: TextStyle(fontSize: 16, color: AppColors.c101426, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          textInputAction: widget.textInputAction,
          style: TextStyle(color: AppColors.c101426, fontSize: 14.sp, fontWeight: FontWeight.w500),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: AppColors.c101426,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  widget.controller?.clear();
                },
                child: SvgPicture.asset(AppIcons.clear),
              ),
            ),
            suffixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: widget.hintText,
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

  @override
  void dispose() {
    widget.controller?.removeListener(_formatInput);
    super.dispose();
  }
}
