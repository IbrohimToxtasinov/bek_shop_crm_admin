import 'package:bek_shop/blocs/order_pdf/order_pdf_bloc.dart';
import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel orderModel;

  const OrderDetailScreen({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderPdfBloc(),
      child: BlocConsumer<OrderPdfBloc, OrderPdfState>(
        listener: (context, state) {
          if (state is OrderPdfError) {
            showOverlayMessage(context, text: state.message);
          }
        },
        builder: (context, state) {
          return AppUiLoadingContainer(
            loadingText:
                state is OrderPdfLoading
                    ? "${tr("creating_pdf")}..."
                    : state is OrderPdfGenerated
                    ? "${tr("pdf_file_created")}!"
                    : null,
            isLoading: state is OrderPdfLoading || state is OrderPdfGenerated,
            child: Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: MainActionButton(
                  label: "view_address_on_map".tr(),
                  onTap: () {
                    _openMapsSheet(context, activeOrders: orderModel);
                  },
                ),
              ),
              appBar: CustomAppBar(
                title: "order_detail".tr(),
                showTrailing: true,
                centerTitle: false,
                trailing: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(AppIcons.edit, width: 24.w, height: 24.h),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterNames.editOrder,
                          arguments: orderModel,
                        );
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(AppIcons.download, width: 24.w, height: 24.h),
                      onPressed: () {
                        context.read<OrderPdfBloc>().add(
                          GenerateAndSharePdfEvent(order: orderModel, share: true),
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📦 ${tr("order_id")}: ${orderModel.orderId}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "👤 ${tr("client")}: ${orderModel.clientName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "📞 ${tr("phone_number")}: ${orderModel.clientPhoneNumber}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "📍 ${tr("address")}: ${orderModel.clientAddress}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '💰 ${tr("total")}: ${NumberFormat.decimalPattern('uz_UZ').format(orderModel.totalPrice)} ${tr("sum")}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade700,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "⏳ ${AppUtils.formatDate(orderModel.createAt)}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "products".tr(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 25.sp,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orderModel.products.length,
                        itemBuilder: (context, index) {
                          OrderProductModel product = orderModel.products[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            width: double.infinity.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouterNames.galleryPhotoViewWrapper,
                                      arguments: product.productImage,
                                    );
                                  },
                                  child: AppCachedNetworkImage(
                                    image: product.productImage,
                                    height: 82,
                                    width: 85,
                                    radius: 8,
                                    iconSize: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName.trim(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.c101010,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${tr("price")}: ${NumberFormat.decimalPattern('uz_UZ').format(product.productPrice)} ${tr("sum")}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.c101010,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${tr("quantity")}: ${product.count} ${product.isCountable ? tr("piece").toLowerCase() : tr("kg").toLowerCase()}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.c101010,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${NumberFormat.decimalPattern('uz_UZ').format(product.count * product.productPrice)} ${tr("sum")}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> _openMapsSheet(BuildContext context, {required OrderModel activeOrders}) async {
  try {
    final coords = Coords(activeOrders.latLong.latitude, activeOrders.latLong.longitude);
    final availableMaps = await MapLauncher.installedMaps;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                for (var map in availableMaps)
                  ListTile(
                    onTap: () => map.showMarker(coords: coords, title: activeOrders.orderId),
                    title: Text(map.mapName, style: TextStyle(color: Colors.black, fontSize: 18)),
                    leading: SvgPicture.asset(map.icon, height: 30.0, width: 30.0),
                  ),
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    showOverlayMessage(context, text: "error_opening_address_on_map".tr());
  }
}
