import 'package:bek_shop/blocs/order_edit_cart/order_edit_cart_bloc.dart';
import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/screens/widgets/bottom_sheets/product_detail_bottom_sheet_screen_for_edit.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductItemForEdit extends StatelessWidget {
  final void Function()? onTap;
  final ProductModel productModel;

  const ProductItemForEdit({super.key, required this.productModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderEditCartBloc, OrderEditCartState>(
      buildWhen: (previous, current) => current is OrderEditCartGetSuccess,
      builder: (context, state) {
        List<OrderProductModel> products = [...state.oldProducts, ...state.newProducts];
        List<OrderProductModel> exists =
            products.where((e) => e.productId == productModel.productId).toList();
        return Opacity(
          opacity: productModel.productActive ? 1 : 0.5,
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.cF2F2F2,
            ),
            child: InkWell(
              onTap: () {
                if (onTap != null) {
                  () => onTap!;
                }
                if (exists.isNotEmpty) {
                  for (var element in products) {
                    OrderProductModel cartModel = products.firstWhere(
                      (element) => element.productId == productModel.productId,
                    );
                    if (element.productId == productModel.productId && cartModel.count != 0) {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        builder: (BuildContext context) {
                          return ProductDetailBottomSheetScreenForEdit(
                            productModel: OrderProductModel(
                              count: cartModel.count,
                              mfgDate: productModel.mfgDate ?? "",
                              expDate: productModel.expDate ?? "",
                              isCountable: productModel.isCountable,
                              productName: productModel.productName,
                              productImage: productModel.productImage,
                              productPrice: productModel.productPrice.toDouble(),
                              productDescription: productModel.productDescription,
                              productId: productModel.productId,
                              categoryId: productModel.categoryId,
                              createdAt: productModel.createdAt,
                              productActive: productModel.productActive,
                              productQuantity: productModel.productQuantity.toInt(),
                            ),
                            cartCount: cartModel.count.toInt(),
                            cartId: cartModel.productId,
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    builder: (BuildContext context) {
                      return ProductDetailBottomSheetScreenForEdit(
                        productModel: OrderProductModel(
                          count: 0,
                          mfgDate: productModel.mfgDate ?? "",
                          expDate: productModel.expDate ?? "",
                          isCountable: productModel.isCountable,
                          productName: productModel.productName,
                          productImage: productModel.productImage,
                          productPrice: productModel.productPrice.toDouble(),
                          productDescription: productModel.productDescription,
                          productId: productModel.productId,
                          categoryId: productModel.categoryId,
                          createdAt: productModel.createdAt,
                          productActive: productModel.productActive,
                          productQuantity: productModel.productQuantity.toInt(),
                        ),
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
                    image: productModel.productImage,
                    height: MediaQuery.of(context).size.width > 600 ? 180.h : 165.h,
                    width: double.infinity,
                    radius: 20.r,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      productModel.productName,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (productModel.productActive)
                    Builder(
                      builder: (context) {
                        List<OrderProductModel> products = [
                          ...state.oldProducts,
                          ...state.newProducts,
                        ];
                        if (exists.isNotEmpty) {
                          for (var element in products) {
                            OrderProductModel cartModel = products.firstWhere(
                              (element) => element.productId == productModel.productId,
                            );
                            if (element.productId == productModel.productId &&
                                cartModel.count != 0) {
                              return Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        if (cartModel.count == 1) {
                                          BlocProvider.of<OrderEditCartBloc>(context).add(
                                            DeleteOrderEditCartProductById(
                                              productId: cartModel.productId,
                                            ),
                                          );
                                        } else {
                                          BlocProvider.of<OrderEditCartBloc>(context).add(
                                            UpdateOrderEditCartProduct(
                                              product: OrderProductModel(
                                                productQuantity: cartModel.productQuantity.toInt(),
                                                productImage: productModel.productImage,
                                                productName: productModel.productName,
                                                productPrice: productModel.productPrice,
                                                productId: productModel.productId,
                                                categoryId: productModel.categoryId,
                                                count: cartModel.count - 1,
                                                isCountable: productModel.isCountable,
                                                createdAt: productModel.createdAt,
                                                productActive: productModel.productActive,
                                                mfgDate: productModel.mfgDate ?? "",
                                                expDate: productModel.expDate ?? "",
                                                productDescription: productModel.productDescription,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: SvgPicture.asset(
                                        AppIcons.minus,
                                        height:
                                            MediaQuery.of(context).size.width > 600 ? 5.h : null,
                                        width:
                                            MediaQuery.of(context).size.width > 600 ? 20.w : null,
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
                                        if (cartModel.productQuantity > cartModel.count) {
                                          BlocProvider.of<OrderEditCartBloc>(context).add(
                                            UpdateOrderEditCartProduct(
                                              product: OrderProductModel(
                                                productQuantity: cartModel.productQuantity.toInt(),
                                                productImage: productModel.productImage,
                                                productName: productModel.productName,
                                                productPrice: productModel.productPrice,
                                                productId: productModel.productId,
                                                categoryId: productModel.categoryId,
                                                count: cartModel.count + 1,
                                                isCountable: productModel.isCountable,
                                                createdAt: productModel.createdAt,
                                                productActive: productModel.productActive,
                                                mfgDate: productModel.mfgDate ?? "",
                                                expDate: productModel.expDate ?? "",
                                                productDescription: productModel.productDescription,
                                              ),
                                            ),
                                          );
                                        } else {
                                          showOverlayMessage(context, text: "no_product".tr());
                                        }
                                      },
                                      icon: SvgPicture.asset(
                                        AppIcons.plus,
                                        height:
                                            MediaQuery.of(context).size.width > 600 ? 20.h : null,
                                        width:
                                            MediaQuery.of(context).size.width > 600 ? 20.w : null,
                                        colorFilter: ColorFilter.mode(
                                          cartModel.productQuantity == cartModel.count
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
                            BlocProvider.of<OrderEditCartBloc>(context).add(
                              AddProductOrderEditCartProducts(
                                product: OrderProductModel(
                                  productQuantity: productModel.productQuantity.toInt(),
                                  productImage: productModel.productImage,
                                  productName: productModel.productName,
                                  productPrice: productModel.productPrice,
                                  productId: productModel.productId,
                                  categoryId: productModel.categoryId,
                                  count: 1,
                                  isCountable: productModel.isCountable,
                                  createdAt: productModel.createdAt,
                                  productActive: productModel.productActive,
                                  mfgDate: productModel.mfgDate ?? "",
                                  expDate: productModel.expDate ?? "",
                                  productDescription: productModel.productDescription,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            height: 40.h,
                            alignment: Alignment.center,
                            child: Text(
                              '${NumberFormat.decimalPattern('uz_UZ').format(productModel.productPrice)} ${tr("sum")}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.c101828,
                              ),
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
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
                      ),
                      child: Text(
                        "not_available".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.c101426,
                          fontSize: 14.sp,
                        ),
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
