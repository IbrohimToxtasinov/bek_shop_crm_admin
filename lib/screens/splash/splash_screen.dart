import 'dart:async';

import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pushNamedAndRemoveUntil(context, AppRouterNames.tabBoxRoute, (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.cFFC34A,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cFFC34A,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset(AppImages.appIconLogo, width: 150)),
            Text("Bek Shop", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
