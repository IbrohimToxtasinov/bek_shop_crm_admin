import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/category/category_bloc.dart';
import 'package:bek_shop/blocs/order/order_bloc.dart';
import 'package:bek_shop/blocs/tab/tab_cubit.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'home/home_screen.dart';
import 'cart/cart_screen.dart';
import 'orders/orders_screen.dart';

class TabBox extends StatefulWidget {
  const TabBox({super.key});

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  List<Widget> tabBoxScreens = [];

  @override
  void initState() {
    context.read<CategoryBloc>().add(FetchCategory());
    context.read<OrderBloc>().add(FetchOrders());
    tabBoxScreens = [HomeScreen(), CartScreen(), OrdersScreen()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, TabState>(
      builder: (context, state) {
        return AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: IndexedStack(index: state.currentIndex, children: tabBoxScreens),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.currentIndex,
                selectedItemColor: AppColors.c101426,
                unselectedItemColor: AppColors.c8F9BB3,
                selectedFontSize: 16.sp,
                unselectedFontSize: 16.sp,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                onTap: (value) {
                  context.read<TabCubit>().changeCurrentIndex(value);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.home, width: 24.w, height: 24.h),
                    activeIcon: SvgPicture.asset(AppIcons.selectedHome, width: 24.w, height: 24.h),
                    label: "home".tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(AppIcons.cart, width: 24.w, height: 24.h),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: BlocBuilder<CartBloc, CartState>(
                            buildWhen: (previous, current) => current is CartLoadInSuccessGet,
                            builder: (context, state) {
                              if (state.products.isNotEmpty) {
                                return Container(
                                  constraints: BoxConstraints(minWidth: 15.w, minHeight: 15.h),
                                  decoration: const BoxDecoration(
                                    color: AppColors.cF14141,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppUtils.cartProductsLength(state.products),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    activeIcon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(AppIcons.selectedCart, width: 24.w, height: 24.h),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: BlocBuilder<CartBloc, CartState>(
                            buildWhen: (previous, current) => current is CartLoadInSuccessGet,
                            builder: (context, state) {
                              if (state.products.isNotEmpty) {
                                return Container(
                                  constraints: BoxConstraints(minWidth: 15.w, minHeight: 15.h),
                                  decoration: const BoxDecoration(
                                    color: AppColors.cF14141,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppUtils.cartProductsLength(state.products),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    label: "cart".tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.orders, width: 24.w, height: 24.h),
                    activeIcon: SvgPicture.asset(
                      AppIcons.selectedOrders,
                      width: 24.w,
                      height: 24.h,
                    ),
                    label: "orders".tr(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
