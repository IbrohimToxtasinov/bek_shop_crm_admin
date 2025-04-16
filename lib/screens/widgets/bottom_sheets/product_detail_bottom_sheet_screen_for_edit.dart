import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/screens/edit_order/widget/add_product_to_order_edit_cart.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/buttons/main_back_button.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailBottomSheetScreenForEdit extends StatefulWidget {
  final bool isViewInOrderDetail;
  final OrderProductModel productModel;
  final int? cartCount;
  final String? cartId;

  const ProductDetailBottomSheetScreenForEdit({
    super.key,
    required this.productModel,
    this.isViewInOrderDetail = false,
    this.cartCount,
    this.cartId,
  });

  @override
  State<ProductDetailBottomSheetScreenForEdit> createState() =>
      _ProductDetailBottomSheetScreenForEditState();
}

class _ProductDetailBottomSheetScreenForEditState
    extends State<ProductDetailBottomSheetScreenForEdit> {
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
                    arguments: widget.productModel.productImage,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18.r),
                    topLeft: Radius.circular(18.r),
                  ),
                  child: AppCachedNetworkImage(
                    image: widget.productModel.productImage,
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
                      widget.productModel.productName,
                      style: TextStyle(
                        color: AppColors.c101828,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        '${NumberFormat.decimalPattern('uz_UZ').format(widget.productModel.productPrice)} ${tr("sum")}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                    Text(
                      widget.productModel.productDescription,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.c878787,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${tr(!widget.isViewInOrderDetail ? "available" : "quantity")}: ${!widget.isViewInOrderDetail ? widget.productModel.productQuantity.toInt() : widget.productModel.count.toInt()} ${widget.productModel.isCountable ? "dona" : "kg"}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                        fontSize: 20.sp,
                      ),
                    ),
                    if (widget.productModel.mfgDate.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          "${tr("mfg_date")}: ${AppUtils.formatProductDate(widget.productModel.mfgDate)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    if (widget.productModel.expDate.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          "${tr("exp_date")}: ${AppUtils.formatProductDate(widget.productModel.expDate)}",
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
              !widget.isViewInOrderDetail
                  ? Padding(
                    padding: EdgeInsets.only(bottom: 0.h),
                    child: AddProductToOrderEditCart(
                      productModel: widget.productModel,
                      cartCount: widget.cartCount,
                      cartId: widget.cartId,
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.all(10.w),
                    child: MainActionButton(
                      onTap: () => Navigator.pop(context),
                      label: "cancel".tr(),
                    ),
                  ),
            ],
          ),
          Positioned(
            top: 10.0.h,
            right: 10.0.w,
            child: MainBackButton(icon: Icons.clear, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
