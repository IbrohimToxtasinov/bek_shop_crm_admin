import 'package:bek_shop/blocs/order/order_bloc.dart';
import 'package:bek_shop/cubits/delete_old_orders/delete_old_orders_cubit.dart';
import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bek_shop/screens/add_category/add_category_screen.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/tab_box/orders/widgets/order_item.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/dialogs/delete_dialog.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DeleteOldOrdersCubit(context.read<OrderRepository>());
      },
      child: BlocConsumer<DeleteOldOrdersCubit, DeleteOldOrdersState>(
        listener: (context, deleteState) {

          if (deleteState is DeleteOldOrdersLoadInFailure) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
        },
        builder: (context, deleteState) {
          return AppUiLoadingContainer(
            isLoading:
                deleteState is DeleteOldOrdersLoadInProgress ||
                deleteState is DeleteOldOrdersLoadInSuccess,
            loadingText:
                deleteState is DeleteOldOrdersLoadInProgress
                    ? "Buyutmalar o'chirilmoqda..."
                    : deleteState is DeleteOldOrdersLoadInSuccess
                    ? "Buyurtmalar muvafiyaqatli o'chirldi!"
                    : null,
            child: Scaffold(
              appBar: CustomAppBar(
                title: "orders".tr(),
                showTrailing: true,
                trailing: Row(
                  children: [
                    IconButton(
                      tooltip: "remove_order".tr(),
                      icon: SvgPicture.asset(
                        AppIcons.deleteBold,
                        width: 24.w,
                        height: 24.h,
                      ),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              content: DeleteDialog(
                                onTap: () {
                                  context
                                      .read<DeleteOldOrdersCubit>()
                                      .deleteOldOrders();
                                  Navigator.pop(context);
                                },
                                text: "remove_order_dialog".tr(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      tooltip: "search".tr(),
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            AppRouterNames.searchOrders,
                          ),
                      icon: SvgPicture.asset(
                        AppIcons.search,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is GetOrderLoadInProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cFFC34A,
                      ),
                    );
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
                    return Center(
                      child: Text("${tr("error")}: ${state.errorText}"),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
