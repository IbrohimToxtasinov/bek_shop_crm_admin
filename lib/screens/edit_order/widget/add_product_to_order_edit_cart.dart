import 'package:bek_shop/blocs/order_edit_cart/order_edit_cart_bloc.dart';
import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddProductToOrderEditCart extends StatefulWidget {
  final num? cartCount;
  final String? cartId;
  final OrderProductModel productModel;

  const AddProductToOrderEditCart(
      {required this.productModel, this.cartCount, this.cartId, super.key});

  @override
  State<AddProductToOrderEditCart> createState() => _AddProductToOrderEditCartState();
}

class _AddProductToOrderEditCartState extends State<AddProductToOrderEditCart> {
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
      padding: EdgeInsets.only(top: 5.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          topLeft: Radius.circular(30.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.r),
          topLeft: Radius.circular(25.r),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
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
                          width: MediaQuery.of(context).size.width > 600 ? 5.w : null,
                          height: MediaQuery.of(context).size.width > 600 ? 5.h : null,
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
                          fontSize: 22.sp,
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
                          width: MediaQuery.of(context).size.width > 600 ? 18.w : null,
                          height: MediaQuery.of(context).size.width > 600 ? 18.h : null,
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
              SizedBox(width: 10.w),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap:
                  widget.productModel.productActive
                      ? () async {
                    if (widget.cartCount == count || count == 0) {
                      BlocProvider.of<OrderEditCartBloc>(context).add(
                        DeleteOrderEditCartProductById(
                          productId: widget.productModel.productId,
                        ),
                      );
                    } else {
                      if (widget.cartCount == null) {
                        BlocProvider.of<OrderEditCartBloc>(context).add(
                          AddProductOrderEditCartProducts(
                            product: OrderProductModel(
                              productActive: widget.productModel.productActive,
                              mfgDate: widget.productModel.mfgDate,
                              expDate: widget.productModel.expDate,
                              isCountable: widget.productModel.isCountable,
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
                        BlocProvider.of<OrderEditCartBloc>(context).add(
                          UpdateOrderEditCartProduct(
                            product: OrderProductModel(
                              productActive: widget.productModel.productActive,
                              mfgDate: widget.productModel.mfgDate,
                              expDate: widget.productModel.expDate,
                              isCountable: widget.productModel.isCountable,
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
                    if (mounted) Navigator.pop(context);
                  }
                      : null,
                  child: Container(
                    height: 50.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                      widget.productModel.productActive ? AppColors.cFFC34A : AppColors.cF2F2F2,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      widget.productModel.productActive
                          ? widget.cartCount == count || count == 0
                          ? "delete".tr()
                          : widget.cartCount == null
                          ? "add".tr()
                          : "update".tr()
                          : "not_available".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
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
