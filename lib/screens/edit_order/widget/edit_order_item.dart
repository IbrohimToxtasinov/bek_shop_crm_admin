import 'package:bek_shop/blocs/order_edit_cart/order_edit_cart_bloc.dart';
import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/screens/widgets/bottom_sheets/product_detail_bottom_sheet_screen_for_edit.dart';
import 'package:bek_shop/screens/widgets/dialogs/delete_dialog.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditOrderItem extends StatelessWidget {
  final OrderProductModel orderProductModel;

  const EditOrderItem({super.key, required this.orderProductModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(22.r),
      onTap: () async {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          builder: (BuildContext context) {
            return ProductDetailBottomSheetScreenForEdit(
              productModel: OrderProductModel(
                updatedAt: orderProductModel.updatedAt,
                count: orderProductModel.count,
                mfgDate: orderProductModel.mfgDate,
                expDate: orderProductModel.expDate,
                isCountable: orderProductModel.isCountable,
                productName: orderProductModel.productName,
                productImage: orderProductModel.productImage,
                productPrice: orderProductModel.productPrice.toDouble(),
                productDescription: orderProductModel.productDescription,
                productId: orderProductModel.productId,
                categoryId: orderProductModel.categoryId,
                createdAt: orderProductModel.createdAt,
                productActive: orderProductModel.productActive,
                productQuantity: orderProductModel.productQuantity,
              ),
              cartCount: orderProductModel.count.toInt(),
              cartId: orderProductModel.productId,
            );
          },
        );
        return;
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        width: double.infinity.w,
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3.r,
              blurRadius: 8.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            AppCachedNetworkImage(
              image: orderProductModel.productImage,
              height: 82.h,
              width: 85.w,
              radius: 8.r,
              iconSize: 30.w,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    orderProductModel.productName.trim(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.c101010,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${NumberFormat.decimalPattern('uz_UZ').format(orderProductModel.productPrice)} ${tr("sum")}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.cFFC34A,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(15.r),
                            onTap: () {
                              if (orderProductModel.count == 1) {
                                BlocProvider.of<OrderEditCartBloc>(context).add(
                                  DeleteOrderEditCartProductById(
                                    productId: orderProductModel.productId,
                                  ),
                                );
                              } else {
                                BlocProvider.of<OrderEditCartBloc>(context).add(
                                  UpdateOrderEditCartProduct(
                                    product: OrderProductModel(
                                      updatedAt: orderProductModel.updatedAt,
                                      productQuantity: orderProductModel.productQuantity,
                                      productImage: orderProductModel.productImage,
                                      productName: orderProductModel.productName,
                                      productPrice: orderProductModel.productPrice,
                                      productId: orderProductModel.productId,
                                      categoryId: orderProductModel.categoryId,
                                      count: orderProductModel.count - 1,
                                      isCountable: orderProductModel.isCountable,
                                      createdAt: orderProductModel.createdAt,
                                      productActive: orderProductModel.productActive,
                                      mfgDate: orderProductModel.mfgDate,
                                      expDate: orderProductModel.expDate,
                                      productDescription: orderProductModel.productDescription,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 30.w,
                              height: 30.h,
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2.w, color: AppColors.cEDEDED),
                              ),
                              child: SvgPicture.asset(AppIcons.minus),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            orderProductModel.count.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.c101010,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          InkWell(
                            borderRadius: BorderRadius.circular(15.r),
                            onTap: () {
                              if (orderProductModel.productQuantity > orderProductModel.count) {
                                BlocProvider.of<OrderEditCartBloc>(context).add(
                                  UpdateOrderEditCartProduct(
                                    product: OrderProductModel(
                                      updatedAt: orderProductModel.updatedAt,
                                      productQuantity: orderProductModel.productQuantity,
                                      productImage: orderProductModel.productImage,
                                      productName: orderProductModel.productName,
                                      productPrice: orderProductModel.productPrice,
                                      productId: orderProductModel.productId,
                                      categoryId: orderProductModel.categoryId,
                                      count: orderProductModel.count + 1,
                                      isCountable: orderProductModel.isCountable,
                                      createdAt: orderProductModel.createdAt,
                                      productActive: orderProductModel.productActive,
                                      mfgDate: orderProductModel.mfgDate,
                                      expDate: orderProductModel.expDate,
                                      productDescription: orderProductModel.productDescription,
                                    ),
                                  ),
                                );
                              } else {
                                showOverlayMessage(context, text: "no_product".tr());
                              }
                            },
                            child: Container(
                              width: 30.w,
                              height: 30.h,
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2.w, color: AppColors.cEDEDED),
                              ),
                              child: SvgPicture.asset(
                                AppIcons.plus,
                                colorFilter: ColorFilter.mode(
                                  orderProductModel.productQuantity == orderProductModel.count
                                      ? Colors.grey
                                      : Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                content: DeleteDialog(
                                  text: "delete_product_cart".tr(),
                                  onTap: () {
                                    BlocProvider.of<OrderEditCartBloc>(context).add(
                                      DeleteOrderEditCartProductById(
                                        productId: orderProductModel.productId,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: SvgPicture.asset(AppIcons.delete, width: 20.w, height: 20.h),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
