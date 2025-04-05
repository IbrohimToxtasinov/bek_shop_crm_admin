import 'dart:async';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showOverlayMessage(
  BuildContext context, {
  required String text,
  Duration? duration,
  OverlayStatus status = OverlayStatus.failed,
}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      return _OverlaySnackBar(
        status: status,
        duration: duration ?? const Duration(seconds: 3),
        text: text,
        onDismissed: () {
          entry.remove();
        },
      );
    },
  );

  overlay.insert(entry);
}

enum OverlayStatus { success, failed }

class _OverlaySnackBar extends StatefulWidget {
  final OverlayStatus status;

  final Duration duration;

  final String text;

  final VoidCallback onDismissed;

  const _OverlaySnackBar({
    required this.status,
    required this.duration,
    required this.text,
    required this.onDismissed,
  });

  @override
  State<_OverlaySnackBar> createState() => _OverlaySnackBarState();
}

class _OverlaySnackBarState extends State<_OverlaySnackBar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () {
      widget.onDismissed.call();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: Material(
            child: Container(
              color: widget.status == OverlayStatus.failed ? AppColors.error : AppColors.positive,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Text(
                widget.text,
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
