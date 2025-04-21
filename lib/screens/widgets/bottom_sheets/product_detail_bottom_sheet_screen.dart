import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/tab_box/cart/widgets/add_product_to_cart.dart';
import 'package:bek_shop/screens/widgets/buttons/main_back_button.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailBottomSheetScreen extends StatelessWidget {
  final ProductModel productModel;
  final bool? isEditView;
  final int? cartCount;
  final int? cartId;
  final int isExpensive;

  const ProductDetailBottomSheetScreen({
    super.key,
    this.isExpensive = 0,
    required this.productModel,
    this.cartCount,
    this.cartId,
    this.isEditView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          topLeft: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterNames.galleryPhotoViewWrapper,
                    arguments: productModel.productImage,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18.r),
                    topLeft: Radius.circular(18.r),
                  ),
                  child: AppCachedNetworkImage(
                    image: productModel.productImage,
                    width: double.infinity,
                    height: 274.h,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.productName,
                      style: TextStyle(
                        color: AppColors.c101828,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        '${NumberFormat.decimalPattern('uz_UZ').format(isExpensive == 1 ? productModel.productPrice + productModel.expensivePrice : productModel.productPrice + productModel.cheapPrice)} ${tr("sum")}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                    Text(
                      productModel.productDescription,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.c878787,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${tr("available")}: ${productModel.productQuantity.toInt()} ${productModel.isCountable ? "dona" : "kg"}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                        fontSize: 20.sp,
                      ),
                    ),
                    if (productModel.mfgDate != null &&
                        productModel.mfgDate!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          "${tr("mfg_date")}: ${AppUtils.formatProductDate(productModel.mfgDate!)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    if (productModel.expDate != null &&
                        productModel.expDate!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          "${tr("exp_date")}: ${AppUtils.formatProductDate(productModel.expDate!)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 0.h),
                child: AddProductToCart(
                  isExpensive: isExpensive,
                  productModel: productModel,
                  cartCount: cartCount,
                  cartId: cartId,
                ),
              ),
            ],
          ),
          Positioned(
            top: 10.0.h,
            right: 10.0.w,
            child: MainBackButton(icon: Icons.clear, color: Colors.white),
          ),
          if (isEditView ?? false)
            Positioned(
              top: 225.0.h,
              right: 10.0.w,
              child: MainBackButton(
                icon: Icons.edit,
                color: Colors.white,
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    AppRouterNames.updateProduct,
                    arguments: productModel,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
