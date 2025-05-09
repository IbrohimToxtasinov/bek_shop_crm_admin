import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/cubits/change_products_cost/change_products_cost_cubit.dart';
import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/screens/widgets/bottom_sheets/product_detail_bottom_sheet_screen.dart';
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

class CartItem extends StatelessWidget {
  final CartModel cartModel;

  const CartItem({super.key, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeProductsCostCubit, ChangeProductsCostState>(
      builder: (context, productPriceState) {
        if (productPriceState is GetProductsCostSuccess) {
          return BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) => current is CartLoadInSuccessGet,
            builder: (context, state) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(22.r),
                onTap: () async {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30.r),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return ProductDetailBottomSheetScreen(
                        productModel: ProductModel(
                          cheapPrice: cartModel.cheapPrice,
                          expensivePrice: cartModel.expensivePrice,
                          updatedAt: cartModel.updatedAt,
                          mfgDate: cartModel.mfgDate,
                          expDate: cartModel.expDate,
                          isCountable:
                              cartModel.isCountable == 1 ? true : false,
                          productName: cartModel.productName,
                          productImage: cartModel.productImage,
                          productPrice: cartModel.productPrice.toDouble(),
                          productDescription: cartModel.productDescription,
                          productId: cartModel.productId,
                          categoryId: cartModel.categoryId,
                          createdAt: cartModel.createdAt,
                          productActive:
                              cartModel.productActive == 1 ? true : false,
                          productQuantity: cartModel.productQuantity,
                        ),
                        isExpensive: cartModel.isExpensive,
                        cartCount: cartModel.count,
                        cartId: cartModel.id,
                      );
                    },
                  );
                  return;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  width: double.infinity.w,
                  height: 123.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3.r,
                        blurRadius: 8.r,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AppCachedNetworkImage(
                        image: cartModel.productImage,
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
                              cartModel.productName.trim(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.c101010,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${NumberFormat.decimalPattern('uz_UZ').format(cartModel.isExpensive == 1 ? cartModel.productPrice + cartModel.expensivePrice : cartModel.productPrice + cartModel.cheapPrice)} ${tr("sum")}',
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
                                      borderRadius: BorderRadius.circular(
                                        15.sp,
                                      ),
                                      onTap: () {
                                        if (cartModel.count == 1) {
                                          BlocProvider.of<CartBloc>(
                                            context,
                                          ).add(
                                            DeleteCartById(id: cartModel.id!),
                                          );
                                        } else {
                                          BlocProvider.of<CartBloc>(
                                            context,
                                          ).add(
                                            UpdateCart(
                                              cartModel: CartModel(
                                                cheapPrice:
                                                    cartModel.cheapPrice,
                                                isExpensive:
                                                    cartModel.isExpensive,
                                                expensivePrice:
                                                    cartModel.expensivePrice,
                                                updatedAt: cartModel.updatedAt,
                                                productActive:
                                                    cartModel.productActive,
                                                mfgDate: cartModel.mfgDate,
                                                expDate: cartModel.expDate,
                                                id: cartModel.id,
                                                isCountable:
                                                    cartModel.isCountable,
                                                categoryId:
                                                    cartModel.categoryId,
                                                productId: cartModel.productId,
                                                productName:
                                                    cartModel.productName,
                                                count: cartModel.count - 1,
                                                productPrice:
                                                    cartModel.productPrice,
                                                createdAt: cartModel.createdAt,
                                                productImage:
                                                    cartModel.productImage,
                                                productDescription:
                                                    cartModel
                                                        .productDescription,
                                                productQuantity:
                                                    cartModel.productQuantity
                                                        .toInt(),
                                              ),
                                            ),
                                          );
                                        }
                                        BlocProvider.of<CartBloc>(
                                          context,
                                        ).add(FetchCarts());
                                      },
                                      child: Container(
                                        width: 30.w,
                                        height: 30.h,
                                        padding: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2.w,
                                            color: AppColors.cEDEDED,
                                          ),
                                        ),
                                        child: SvgPicture.asset(AppIcons.minus),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Text(
                                      cartModel.count.toString(),
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
                                        if (cartModel.productQuantity >
                                            cartModel.count) {
                                          BlocProvider.of<CartBloc>(
                                            context,
                                          ).add(
                                            UpdateCart(
                                              cartModel: CartModel(
                                                cheapPrice:
                                                    cartModel.cheapPrice,
                                                isExpensive:
                                                    cartModel.isExpensive,
                                                expensivePrice:
                                                    cartModel.expensivePrice,
                                                updatedAt: cartModel.updatedAt,
                                                productActive:
                                                    cartModel.productActive,
                                                id: cartModel.id,
                                                mfgDate: cartModel.mfgDate,
                                                expDate: cartModel.expDate,
                                                isCountable:
                                                    cartModel.isCountable,
                                                categoryId:
                                                    cartModel.categoryId,
                                                productId: cartModel.productId,
                                                productName:
                                                    cartModel.productName,
                                                count: cartModel.count + 1,
                                                productPrice:
                                                    cartModel.productPrice,
                                                createdAt: cartModel.createdAt,
                                                productImage:
                                                    cartModel.productImage,
                                                productDescription:
                                                    cartModel
                                                        .productDescription,
                                                productQuantity:
                                                    cartModel.productQuantity
                                                        .toInt(),
                                              ),
                                            ),
                                          );
                                          BlocProvider.of<CartBloc>(
                                            context,
                                          ).add(FetchCarts());
                                        } else {
                                          showOverlayMessage(
                                            context,
                                            text: "no_product".tr(),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 30.w,
                                        height: 30.h,
                                        padding: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2.w,
                                            color: AppColors.cEDEDED,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          AppIcons.plus,
                                          colorFilter: ColorFilter.mode(
                                            cartModel.productQuantity ==
                                                    cartModel.count
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
                                              BlocProvider.of<CartBloc>(
                                                context,
                                              ).add(
                                                DeleteCartById(
                                                  id: cartModel.id!,
                                                ),
                                              );
                                              BlocProvider.of<CartBloc>(
                                                context,
                                              ).add(FetchCarts());
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    AppIcons.delete,
                                    width: 20.w,
                                    height: 20.h,
                                  ),
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
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
