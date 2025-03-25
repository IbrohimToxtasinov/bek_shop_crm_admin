import 'package:flutter/material.dart';

class AppUiLoadingContainer extends StatelessWidget {
  final String? loadingText;

  final bool? isLoading;

  final Color? color;

  final Widget? child;

  final EdgeInsetsGeometry? padding;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? margin;

  final Color? progressColor;

  const AppUiLoadingContainer({
    super.key,
    this.loadingText,
    this.isLoading,
    this.child,
    this.color,
    this.padding,
    this.height,
    this.width,
    this.margin,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final isNotNullLoading = isLoading ?? false;
    return WillPopScope(
      onWillPop: isNotNullLoading ? () async => false : null,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            child!,
            Visibility(
              visible: isNotNullLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(progressColor ?? Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      loadingText ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
