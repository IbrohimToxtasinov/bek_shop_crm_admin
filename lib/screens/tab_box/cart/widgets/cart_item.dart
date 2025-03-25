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

class CartItem extends StatefulWidget {
  final CartModel cartModel;

  const CartItem({super.key, required this.cartModel});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
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
                    mfgDate: widget.cartModel.mfgDate,
                    expDate: widget.cartModel.expDate,
                    isCountable: widget.cartModel.isCountable == 1 ? true : false,
                    productName: widget.cartModel.productName,
                    productImage: widget.cartModel.productImage,
                    productPrice: widget.cartModel.productPrice.toDouble(),
                    productDescription: widget.cartModel.productDescription,
                    productId: widget.cartModel.productId,
                    categoryId: widget.cartModel.categoryId,
                    createdAt: widget.cartModel.createdAt,
                    productActive: true,
                    productQuantity: widget.cartModel.productQuantity,
                  ),
                  cartCount: widget.cartModel.count,
                  cartId: widget.cartModel.id,
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
                  image: widget.cartModel.productImage,
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
                        widget.cartModel.productName.trim(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.c101010,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat.decimalPattern('uz_UZ').format(widget.cartModel.productPrice)} ${tr("sum")}',
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
                                  if (widget.cartModel.count == 1) {
                                    BlocProvider.of<CartBloc>(
                                      context,
                                    ).add(DeleteCartById(id: widget.cartModel.id!));
                                  } else {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCart(
                                        cartModel: CartModel(
                                          mfgDate: widget.cartModel.mfgDate,
                                          expDate: widget.cartModel.expDate,
                                          id: widget.cartModel.id,
                                          isCountable: widget.cartModel.isCountable,
                                          categoryId: widget.cartModel.categoryId,
                                          productId: widget.cartModel.productId,
                                          productName: widget.cartModel.productName,
                                          count: widget.cartModel.count - 1,
                                          productPrice: widget.cartModel.productPrice,
                                          createdAt: widget.cartModel.createdAt,
                                          productImage: widget.cartModel.productImage,
                                          productDescription: widget.cartModel.productDescription,
                                          productQuantity: widget.cartModel.productQuantity.toInt(),
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
                                widget.cartModel.count.toString(),
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
                                  if (widget.cartModel.productQuantity > widget.cartModel.count) {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCart(
                                        cartModel: CartModel(
                                          id: widget.cartModel.id,
                                          mfgDate: widget.cartModel.mfgDate,
                                          expDate: widget.cartModel.expDate,
                                          isCountable: widget.cartModel.isCountable,
                                          categoryId: widget.cartModel.categoryId,
                                          productId: widget.cartModel.productId,
                                          productName: widget.cartModel.productName,
                                          count: widget.cartModel.count + 1,
                                          productPrice: widget.cartModel.productPrice,
                                          createdAt: widget.cartModel.createdAt,
                                          productImage: widget.cartModel.productImage,
                                          productDescription: widget.cartModel.productDescription,
                                          productQuantity: widget.cartModel.productQuantity.toInt(),
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
                                      widget.cartModel.productQuantity == widget.cartModel.count
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
                                        ).add(DeleteCartById(id: widget.cartModel.id!));
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
