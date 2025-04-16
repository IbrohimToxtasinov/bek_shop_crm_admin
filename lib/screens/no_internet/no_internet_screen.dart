import 'package:bek_shop/blocs/connectivity/connectivity_bloc.dart';
import 'package:bek_shop/cubits/connectivity/connectivity_cubit.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, required this.voidCallback});

  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (context, state) {
          if (state.connectivityResult != ConnectivityResult.none) {
            voidCallback.call();
            Navigator.pop(context);
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 70.h,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "internet_error".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22.sp,
                      color: AppColors.c101828,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: LottieBuilder.asset(
                      AppImages.noInternet,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 50.h,
                  ),
                  child: MainActionButton(
                    label: "try_again".tr(),
                    onTap: () {
                      BlocProvider.of<ConnectivityCubit>(
                        context,
                      ).checkInternet();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
