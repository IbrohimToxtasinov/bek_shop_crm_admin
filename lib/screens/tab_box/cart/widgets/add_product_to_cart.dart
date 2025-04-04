import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddProductToCart extends StatefulWidget {
  final num? cartCount;
  final int? cartId;
  final ProductModel productModel;

  const AddProductToCart({required this.productModel, this.cartCount, this.cartId, super.key});

  @override
  State<AddProductToCart> createState() => _AddProductToCartState();
}

class _AddProductToCartState extends State<AddProductToCart> {
  num count = 1;

  @override
  void initState() {
    count = widget.cartCount ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.cF2F2F2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        highlightColor: Colors.transparent,
                        onPressed:
                            widget.productModel.productActive
                                ? () {
                                  setState(() {
                                    if (widget.cartCount != null) {
                                      if (count != 0) {
                                        count--;
                                        return;
                                      }
                                    } else {
                                      if (count != 1) {
                                        count--;
                                        return;
                                      }
                                    }
                                  });
                                }
                                : null,
                        icon: SvgPicture.asset(
                          AppIcons.minus,
                          colorFilter:
                              !widget.productModel.productActive
                                  ? const ColorFilter.mode(AppColors.c878787, BlendMode.srcIn)
                                  : null,
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          color: AppColors.cFFC34A,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        onPressed:
                            widget.productModel.productActive
                                ? () {
                                  if (widget.productModel.productQuantity > count) {
                                    setState(() {
                                      if (count != 1000) {
                                        count++;
                                      }
                                    });
                                  } else {
                                    showOverlayMessage(context, text: "no_product".tr());
                                  }
                                }
                                : null,
                        icon: SvgPicture.asset(
                          AppIcons.plus,
                          colorFilter:
                              !widget.productModel.productActive
                                  ? ColorFilter.mode(AppColors.c878787, BlendMode.srcIn)
                                  : ColorFilter.mode(
                                    widget.productModel.productQuantity == count
                                        ? Colors.grey
                                        : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap:
                      widget.productModel.productActive
                          ? () async {
                            if (widget.cartCount == count || count == 0) {
                              BlocProvider.of<CartBloc>(
                                context,
                              ).add(DeleteCartById(id: widget.cartId!));
                            } else {
                              if (widget.cartCount == null) {
                                BlocProvider.of<CartBloc>(context).add(
                                  AddCart(
                                    cartModel: CartModel(
                                      productActive: widget.productModel.productActive ? 1: 0,
                                      mfgDate: widget.productModel.mfgDate,
                                      expDate: widget.productModel.expDate,
                                      isCountable: widget.productModel.isCountable ? 1 : 0,
                                      categoryId: widget.productModel.categoryId,
                                      productId: widget.productModel.productId,
                                      productName: widget.productModel.productName,
                                      count: count.toInt(),
                                      productPrice: widget.productModel.productPrice,
                                      createdAt: widget.productModel.createdAt,
                                      productImage: widget.productModel.productImage,
                                      productDescription: widget.productModel.productDescription,
                                      productQuantity: widget.productModel.productQuantity.toInt(),
                                    ),
                                  ),
                                );
                              } else {
                                BlocProvider.of<CartBloc>(context).add(
                                  UpdateCart(
                                    cartModel: CartModel(
                                      productActive: widget.productModel.productActive ? 1: 0,
                                      mfgDate: widget.productModel.mfgDate,
                                      expDate: widget.productModel.expDate,
                                      id: widget.cartId,
                                      isCountable: widget.productModel.isCountable ? 1 : 0,
                                      categoryId: widget.productModel.categoryId,
                                      productId: widget.productModel.productId,
                                      productName: widget.productModel.productName,
                                      count: count.toInt(),
                                      createdAt: widget.productModel.createdAt,
                                      productPrice: widget.productModel.productPrice,
                                      productImage: widget.productModel.productImage,
                                      productDescription: widget.productModel.productDescription,
                                      productQuantity: widget.productModel.productQuantity.toInt(),
                                    ),
                                  ),
                                );
                              }
                            }
                            BlocProvider.of<CartBloc>(context).add(FetchCarts());
                            if (mounted) Navigator.pop(context);
                          }
                          : null,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          widget.productModel.productActive ? AppColors.cFFC34A : AppColors.cF2F2F2,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.productModel.productActive
                          ? widget.cartCount == count || count == 0
                              ? "delete".tr()
                              : widget.cartCount == null
                              ? "add_cart".tr()
                              : "update_cart".tr()
                          : "not_available".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            widget.productModel.productActive
                                ? AppColors.c101426
                                : AppColors.c878787,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
