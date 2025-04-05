import 'package:bek_shop/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalCostButton extends StatelessWidget {
  final void Function()? onTap;
  final String productCount;
  final num totalCost;

  const TotalCostButton({
    super.key,
    required this.onTap,
    required this.productCount,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.cFFC34A,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 35.h,
                    width: 35.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.c101426,
                    ),
                    child: Text(
                      productCount,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 14.sp),
                    ),
                  ),
                   SizedBox(width: 5.w),
                  Text(
                    "total_cost".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.c101426,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Text(
                '${NumberFormat.decimalPattern('uz_UZ').format(totalCost)} ${tr("sum")}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.c101426,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
