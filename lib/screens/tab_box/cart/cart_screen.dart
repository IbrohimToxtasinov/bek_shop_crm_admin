import 'package:app_settings/app_settings.dart';
import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/location/location_bloc.dart';
import 'package:bek_shop/data/repositories/yandex_geo_repository.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:lottie/lottie.dart';
import 'package:bek_shop/screens/tab_box/cart/widgets/cart_products_widget.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/bottom_sheets/location_settings_bottom_sheets.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/dialogs/delete_dialog.dart';
import 'package:bek_shop/screens/widgets/dialogs/location_loading_dialog.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(context.read<YandexGeoRepository>()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "cart".tr(),
          showTrailing: true,
          trailing: IconButton(
            tooltip: "delete_cart".tr(),
            icon: SvgPicture.asset(AppIcons.deleteBold, width: 24.w, height: 24.h),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: DeleteDialog(
                      onTap: () {
                        BlocProvider.of<CartBloc>(context).add(DeleteCart());
                        BlocProvider.of<CartBloc>(context).add(FetchCarts());
                        Navigator.pop(context);
                      },
                      text: "remove_cart".tr(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) => current is CartLoadInSuccessGet,
          builder: (context, state) {
            if (state is CartLoadInProgressGet) {
              return const Center(child: CircularProgressIndicator(color: AppColors.cFFC34A));
            } else if (state is CartLoadInSuccessGet) {
              return state.products.isNotEmpty
                  ? CartProducts(cartProducts: state.products)
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppIcons.emptyCart, height: 150.h, width: 200.w),
                        SizedBox(height: 24.h),
                        Text(
                          "empty_cart".tr(),
                          style: TextStyle(fontSize: 25.sp, color: AppColors.c8F9BB3),
                        ),
                      ],
                    ),
                  );
            } else if (state is CartLoadInFailureGet) {
              return Center(child: Text(state.errorText));
            } else {
              return SizedBox();
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) => current is CartLoadInSuccessGet,
          builder: (context, state) {
            return SizedBox(
              height: state.products.isNotEmpty ? 122.h : 0.h,
              width: double.infinity,
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    '${NumberFormat.decimalPattern('uz_UZ').format(AppUtils.totalPrice(state.products))} ${tr("sum")}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.c222B45,
                    ),
                  ),
                  Text("total".tr(), style: TextStyle(fontSize: 16.sp, color: AppColors.c222B45)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h),
                    child: BlocListener<LocationBloc, LocationState>(
                      listener: (context, locationState) {
                        if (locationState is LocationLoading) {
                          showDialog(
                            barrierDismissible: false,
                            builder:
                                (context) =>
                                    LoadingDialog(widget: Lottie.asset(AppImages.locationLoading)),
                            context: context,
                          );
                        }
                        if (locationState is LocationPermissionGranted) {
                          Navigator.popAndPushNamed(
                            context,
                            AppRouterNames.createNewOrder,
                            arguments: {
                              "addressName": locationState.addressName,
                              "latLongModel": locationState.latLongModel,
                              "products": state.products,
                            },
                          );
                        }
                        if (locationState is GetAddressNameFailure) {
                          showOverlayMessage(
                            context,
                            text: "location_name_could_not_determined".tr(),
                          );
                          Navigator.popAndPushNamed(
                            context,
                            AppRouterNames.createNewOrder,
                            arguments: {
                              "latLongModel": locationState.latLongModel,
                              "products": state.products,
                            },
                          );
                        }
                        if (locationState is LocationPermissionDeniedForever ||
                            locationState is LocationPermissionDeniedForever) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32.r),
                                topLeft: Radius.circular(32.r),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return LocationSettingsBottomSheet(
                                onTap: () {
                                  AppSettings.openAppSettings(type: AppSettingsType.settings);
                                  Navigator.pop(context);
                                },
                                title: "location_permission".tr(),
                                subTitle: "please_enable_location_permission".tr(),
                                icon: AppIcons.appSettings,
                                buttonText: "open_settings".tr(),
                              );
                            },
                          );
                        }
                        if (locationState is LocationServiceDisabled) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32.r),
                                topLeft: Radius.circular(32.r),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return LocationSettingsBottomSheet(
                                onTap: () {
                                  AppSettings.openAppSettings(type: AppSettingsType.location);
                                  Navigator.pop(context);
                                },
                                title: "location_disabled".tr(),
                                subTitle: "please_enable_location".tr(),
                                icon: AppIcons.locationPermission,
                                buttonText: "open_settings".tr(),
                              );
                            },
                          );
                        }
                      },
                      child: MainActionButton(
                        enabled: true,
                        label: "create_order".tr(),
                        onTap: () {
                          BlocProvider.of<LocationBloc>(
                            context,
                          ).add(RequestLocationPermission(delay: 0));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
