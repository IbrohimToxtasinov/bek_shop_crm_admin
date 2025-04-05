import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderModel;

  const OrderItem({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(22.r),
      onTap: () {
        Navigator.pushNamed(context, AppRouterNames.orderDetailRoute, arguments: orderModel);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.r,
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📦 ${tr("order_id")}: ${orderModel.orderId}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "👤 ${tr("client")}: ${orderModel.clientName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "📞 ${tr("phone_number")}: ${orderModel.clientPhoneNumber}",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "📍 ${tr("address")}: ${orderModel.clientAddress}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '💰 ${tr("total")}: ${NumberFormat.decimalPattern('uz_UZ').format(orderModel.totalPrice)} ${tr("sum")}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.green.shade700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "⏳ ${AppUtils.formatDate(orderModel.createAt)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
