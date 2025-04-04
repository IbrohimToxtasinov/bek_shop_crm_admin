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

  const ProductDetailBottomSheetScreen({
    super.key,
    required this.productModel,
    this.cartCount,
    this.cartId,
    this.isEditView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
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
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  child: AppCachedNetworkImage(
                    image: productModel.productImage,
                    width: double.infinity,
                    height: 274,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.productName,
                      style: TextStyle(
                        color: AppColors.c101828,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${NumberFormat.decimalPattern('uz_UZ').format(productModel.productPrice)} ${tr("sum")}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Text(
                      productModel.productDescription,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.c878787,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${tr("available")}: ${productModel.productQuantity.toInt()} ${productModel.isCountable ? "dona" : "kg"}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                    if (productModel.mfgDate != null && productModel.mfgDate!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "${tr("mfg_date")}: ${AppUtils.formatProductDate(productModel.mfgDate!)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    if (productModel.expDate != null && productModel.expDate!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "${tr("exp_date")}: ${AppUtils.formatProductDate(productModel.expDate!)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: AddProductToCart(
                  productModel: productModel,
                  cartCount: cartCount,
                  cartId: cartId,
                ),
              ),
            ],
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: MainBackButton(icon: Icons.clear, color: Colors.white),
          ),
          if (isEditView ?? false)
            Positioned(
              top: 225.0,
              right: 10.0,
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
