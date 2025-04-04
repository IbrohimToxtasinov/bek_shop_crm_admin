import 'package:bek_shop/blocs/cart/cart_bloc.dart';
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
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => current is CartLoadInSuccessGet,
      builder: (context, state) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          onTap: () async {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              builder: (BuildContext context) {
                return ProductDetailBottomSheetScreen(
                  productModel: ProductModel(
                    mfgDate: cartModel.mfgDate,
                    expDate: cartModel.expDate,
                    isCountable: cartModel.isCountable == 1 ? true : false,
                    productName: cartModel.productName,
                    productImage: cartModel.productImage,
                    productPrice: cartModel.productPrice.toDouble(),
                    productDescription: cartModel.productDescription,
                    productId: cartModel.productId,
                    categoryId: cartModel.categoryId,
                    createdAt: cartModel.createdAt,
                    productActive: cartModel.productActive == 1 ? true : false,
                    productQuantity: cartModel.productQuantity,
                  ),
                  cartCount: cartModel.count,
                  cartId: cartModel.id,
                );
              },
            );
            return;
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity.w,
            height: 110.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                AppCachedNetworkImage(
                  image: cartModel.productImage,
                  height: 82,
                  width: 85,
                  radius: 8,
                  iconSize: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        cartModel.productName.trim(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.c101010,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat.decimalPattern('uz_UZ').format(cartModel.productPrice)} ${tr("sum")}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.cFFC34A,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (cartModel.count == 1) {
                                    BlocProvider.of<CartBloc>(
                                      context,
                                    ).add(DeleteCartById(id: cartModel.id!));
                                  } else {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCart(
                                        cartModel: CartModel(
                                          productActive: cartModel.productActive,
                                          mfgDate: cartModel.mfgDate,
                                          expDate: cartModel.expDate,
                                          id: cartModel.id,
                                          isCountable: cartModel.isCountable,
                                          categoryId: cartModel.categoryId,
                                          productId: cartModel.productId,
                                          productName: cartModel.productName,
                                          count: cartModel.count - 1,
                                          productPrice: cartModel.productPrice,
                                          createdAt: cartModel.createdAt,
                                          productImage: cartModel.productImage,
                                          productDescription: cartModel.productDescription,
                                          productQuantity: cartModel.productQuantity.toInt(),
                                        ),
                                      ),
                                    );
                                  }
                                  BlocProvider.of<CartBloc>(context).add(FetchCarts());
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2, color: AppColors.cEDEDED),
                                  ),
                                  child: SvgPicture.asset(AppIcons.minus),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                cartModel.count.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.c101010,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (cartModel.productQuantity > cartModel.count) {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCart(
                                        cartModel: CartModel(
                                          productActive: cartModel.productActive,
                                          id: cartModel.id,
                                          mfgDate: cartModel.mfgDate,
                                          expDate: cartModel.expDate,
                                          isCountable: cartModel.isCountable,
                                          categoryId: cartModel.categoryId,
                                          productId: cartModel.productId,
                                          productName: cartModel.productName,
                                          count: cartModel.count + 1,
                                          productPrice: cartModel.productPrice,
                                          createdAt: cartModel.createdAt,
                                          productImage: cartModel.productImage,
                                          productDescription: cartModel.productDescription,
                                          productQuantity: cartModel.productQuantity.toInt(),
                                        ),
                                      ),
                                    );
                                    BlocProvider.of<CartBloc>(context).add(FetchCarts());
                                  } else {
                                    showOverlayMessage(context, text: "no_product".tr());
                                  }
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2, color: AppColors.cEDEDED),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.plus,
                                    colorFilter: ColorFilter.mode(
                                      cartModel.productQuantity == cartModel.count
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
                                        ).add(DeleteCartById(id: cartModel.id!));
                                        BlocProvider.of<CartBloc>(context).add(FetchCarts());
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(AppIcons.delete),
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
  }
}
