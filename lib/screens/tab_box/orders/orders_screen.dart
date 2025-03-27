import 'package:bek_shop/blocs/order/order_bloc.dart';
import 'package:bek_shop/screens/tab_box/orders/widgets/order_item.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "orders".tr()),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is GetOrderLoadInProgress) {
            return Center(child: CircularProgressIndicator(color: AppColors.cFFC34A));
          } else if (state is GetOrderLoadInSuccess) {
            if (state.orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Lottie.asset(AppImages.emptyBox, repeat: false),
                      SizedBox(height: 24),
                      Text(
                        "orders_not_available".tr(),
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.c101426,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return OrderItem(orderModel: state.orders[index]);
                },
              );
            }
          } else if (state is GetOrderLoadInFailure) {
            return Center(child: Text("${tr("error")}: ${state.errorText}"));
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
