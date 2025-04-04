import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/bottom_sheets/product_detail_bottom_sheet_screen.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProductItem extends StatefulWidget {
  final void Function()? onTap;
  final ProductModel productModel;

  const ProductItem({super.key, required this.productModel, this.onTap});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => current is CartLoadInSuccessGet,
      builder: (context, state) {
        List<CartModel> exists = state.products
            .where((e) => e.productId == widget.productModel.productId)
            .toList();
        return Opacity(
          opacity: widget.productModel.productActive ? 1 : 0.5,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.cF2F2F2,
            ),
            child: InkWell(
              onLongPress: () {
                Navigator.pushNamed(
                  context,
                  AppRouterNames.updateProduct,
                  arguments: widget.productModel,
                );
              },
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                }
                if (exists.isNotEmpty) {
                  for (var element in state.products) {
                    CartModel cartModel = state.products.firstWhere(
                      (element) =>
                          element.productId == widget.productModel.productId,
                    );
                    if (element.productId == widget.productModel.productId &&
                        cartModel.count != 0) {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        builder: (BuildContext context) {
                          return ProductDetailBottomSheetScreen(
                            isEditView: true,
                            productModel: widget.productModel,
                            cartCount: cartModel.count,
                            cartId: cartModel.id,
                          );
                        },
                      );
                      return;
                    }
                  }
                } else {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    builder: (BuildContext context) {
                      return ProductDetailBottomSheetScreen(
                        isEditView: true,
                        productModel: widget.productModel,
                      );
                    },
                  );
                  return;
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCachedNetworkImage(
                    image: widget.productModel.productImage,
                    height: 180.h,
                    width: double.infinity,
                    radius: 20.r,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.productModel.productName,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (widget.productModel.productActive)
                    Builder(
                      builder: (context) {
                        if (exists.isNotEmpty) {
                          for (var element in state.products) {
                            CartModel cartModel = state.products.firstWhere(
                              (element) =>
                                  element.productId ==
                                  widget.productModel.productId,
                            );
                            if (element.productId ==
                                    widget.productModel.productId &&
                                cartModel.count != 0) {
                              return Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        if (cartModel.count == 1) {
                                          BlocProvider.of<CartBloc>(
                                            context,
                                          ).add(DeleteCartById(
                                              id: cartModel.id!));
                                        } else {
                                          BlocProvider.of<CartBloc>(context)
                                              .add(
                                            UpdateCart(
                                              cartModel: CartModel(
                                                id: element.id,
                                                productActive:
                                                    widget.productModel.productActive ? 1 : 0,
                                                mfgDate: widget.productModel.mfgDate,
                                                expDate: widget.productModel.expDate,
                                                isCountable: element.isCountable,
                                                categoryId: widget.productModel.categoryId,
                                                productId: widget.productModel.productId,
                                                productName: widget.productModel.productName,
                                                count: cartModel.count - 1,
                                                productPrice: widget
                                                    .productModel.productPrice,
                                                createdAt: widget
                                                    .productModel.createdAt,
                                                productImage: widget
                                                    .productModel.productImage,
                                                productDescription: widget
                                                    .productModel
                                                    .productDescription,
                                                productQuantity: widget
                                                    .productModel
                                                    .productQuantity
                                                    .toInt(),
                                              ),
                                            ),
                                          );
                                        }
                                        BlocProvider.of<CartBloc>(context)
                                            .add(FetchCarts());
                                      },
                                      icon: SvgPicture.asset(
                                        AppIcons.minus,
                                        height: 5.h,
                                        width: 20.w,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      cartModel.count.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.cFFC34A,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (widget
                                                .productModel.productQuantity >
                                            cartModel.count) {
                                          BlocProvider.of<CartBloc>(context)
                                              .add(
                                            UpdateCart(
                                              cartModel: CartModel(
                                                productActive:
                                                    widget.productModel.productActive ? 1 : 0,
                                                mfgDate: widget.productModel.mfgDate,
                                                expDate: widget.productModel.expDate,
                                                id: element.id,
                                                isCountable: widget.productModel
                                                        .isCountable
                                                    ? 1
                                                    : 0,
                                                categoryId: widget
                                                    .productModel.categoryId,
                                                productId: widget
                                                    .productModel.productId,
                                                productName: widget
                                                    .productModel.productName,
                                                count: cartModel.count + 1,
                                                productPrice: widget
                                                    .productModel.productPrice,
                                                createdAt: widget
                                                    .productModel.createdAt,
                                                productImage: widget
                                                    .productModel.productImage,
                                                productDescription: widget
                                                    .productModel
                                                    .productDescription,
                                                productQuantity: widget
                                                    .productModel
                                                    .productQuantity
                                                    .toInt(),
                                              ),
                                            ),
                                          );
                                          BlocProvider.of<CartBloc>(context)
                                              .add(FetchCarts());
                                        } else {
                                          showOverlayMessage(context,
                                              text: "no_product".tr());
                                        }
                                      },
                                      icon: SvgPicture.asset(
                                        AppIcons.plus,
                                        height: 20.h,
                                        width: 20.w,
                                        colorFilter: ColorFilter.mode(
                                          widget.productModel.productQuantity ==
                                                  cartModel.count
                                              ? Colors.grey
                                              : Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      highlightColor: Colors.transparent,
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            BlocProvider.of<CartBloc>(context).add(
                              AddCart(
                                cartModel: CartModel(
                                  productActive: widget.productModel.productActive ? 1 : 0,
                                  mfgDate: widget.productModel.mfgDate,
                                  expDate: widget.productModel.expDate,
                                  isCountable:
                                      widget.productModel.isCountable ? 1 : 0,
                                  categoryId: widget.productModel.categoryId,
                                  productId: widget.productModel.productId,
                                  productName: widget.productModel.productName,
                                  count: 1,
                                  productPrice:
                                      widget.productModel.productPrice,
                                  createdAt: widget.productModel.createdAt,
                                  productImage:
                                      widget.productModel.productImage,
                                  productDescription:
                                      widget.productModel.productDescription,
                                  productQuantity: widget
                                      .productModel.productQuantity
                                      .toInt(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 40.h,
                            alignment: Alignment.center,
                            child: Text(
                              '${NumberFormat.decimalPattern('uz_UZ').format(widget.productModel.productPrice)} ${tr("sum")}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.c101828,
                                  fontSize: 14.sp),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Text(
                        "not_available".tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.c101426,
                            fontSize: 14.sp),
                      ),
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
