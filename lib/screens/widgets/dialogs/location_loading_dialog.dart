import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends StatelessWidget {
  final Widget widget;

  const LoadingDialog({required this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r).r)),
      content: Builder(
        builder: (context) {
          return SizedBox(width: 200.w, height: 200.h, child: widget);
        },
      ),
    );
  }
}
