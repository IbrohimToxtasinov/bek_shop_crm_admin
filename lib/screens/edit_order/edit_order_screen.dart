import 'dart:async';

import 'package:bek_shop/blocs/order/order_bloc.dart';
import 'package:bek_shop/blocs/order_edit_cart/order_edit_cart_bloc.dart';
import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/screens/add_category/add_category_screen.dart';
import 'package:bek_shop/screens/edit_order/widget/edit_order_item.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/dialogs/delete_dialog.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditOrderScreen extends StatefulWidget {
  final OrderModel orderModel;

  const EditOrderScreen({super.key, required this.orderModel});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  @override
  void initState() {
    context.read<OrderEditCartBloc>().add(
      OrderEditCartProductsEqualsToCart(products: widget.orderModel.products),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return OrderBloc(context.read<OrderRepository>(), context.read<ProductRepository>());
      },
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is EditOrderInFailure) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
          if (state is DeleteOrderInFailure) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
          if (state is UpdateProductInFailure) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
          if (state is UpdateProductLoadInSuccess) {
            Timer(const Duration(seconds: 2), () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouterNames.tabBoxRoute,
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          return AppUiLoadingContainer(
            isLoading:
                state is DeleteOrderLoadInProgress ||
                state is DeleteOrderLoadInSuccess ||
                state is EditOrderLoadInProgress ||
                state is EditOrderLoadInSuccess ||
                state is UpdateProductLoadInProgress ||
                state is UpdateProductLoadInSuccess,
            loadingText:
                state is DeleteOrderLoadInSuccess
                    ? "${tr("order_deleted")}!"
                    : state is DeleteOrderLoadInProgress
                    ? "${tr("deleting_order")}..."
                    : state is EditOrderLoadInProgress
                    ? "${tr("editing_order")}..."
                    : state is EditOrderLoadInSuccess
                    ? "${tr("order_edited")}!"
                    : state is UpdateProductLoadInProgress
                    ? "${tr("products_update_database")}..."
                    : "${tr("products_updated_success")}!",
            child: Scaffold(
              bottomNavigationBar: BlocBuilder<OrderEditCartBloc, OrderEditCartState>(
                buildWhen: (previous, current) => current is OrderEditCartGetSuccess,
                builder: (context, state) {
                  return SizedBox(
                    height: [...state.newProducts, ...state.oldProducts].isNotEmpty ? 140.h : 0,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          '${NumberFormat.decimalPattern('uz_UZ').format(AppUtils.totalPriceForEdit([...state.oldProducts, ...state.newProducts]))} ${tr("sum")}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.c222B45,
                          ),
                        ),
                        Text(
                          "total".tr(),
                          style: TextStyle(fontSize: 16.sp, color: AppColors.c222B45),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h),
                          child: MainActionButton(
                            label: "edit_order".tr(),
                            onTap: () {
                              BlocProvider.of<OrderBloc>(context).add(
                                EditOrder(
                                  deleteProducts: [...widget.orderModel.products],
                                  orderModel: OrderModel(
                                    orderId: widget.orderModel.orderId,
                                    clientName: widget.orderModel.clientName,
                                    clientPhoneNumber: widget.orderModel.clientPhoneNumber,
                                    clientAddress: widget.orderModel.clientAddress,
                                    createAt: widget.orderModel.createAt,
                                    totalPrice: widget.orderModel.totalPrice,
                                    latLong: widget.orderModel.latLong,
                                    products: [...state.newProducts, ...state.oldProducts],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              appBar: CustomAppBar(
                title: "edit_order".tr(),
                centerTitle: false,
                showTrailing: true,
                trailing: Row(
                  children: [
                    IconButton(
                      tooltip: "add_product".tr(),
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            AppRouterNames.searchProductsForEditOrder,
                          ),
                      icon: SvgPicture.asset(AppIcons.add, width: 24.w, height: 24.h),
                    ),
                    IconButton(
                      tooltip: "remove_order".tr(),
                      icon: SvgPicture.asset(AppIcons.deleteBold, width: 24.w, height: 24.h),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              content: DeleteDialog(
                                onTap: () {
                                  BlocProvider.of<OrderBloc>(context).add(
                                    DeleteOrderById(
                                      deleteProducts: widget.orderModel.products,
                                      orderId: widget.orderModel.orderId,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                text: "remove_order_dialog".tr(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: BlocBuilder<OrderEditCartBloc, OrderEditCartState>(
                buildWhen: (previous, current) => current is OrderEditCartGetSuccess,
                builder: (context, state) {
                  if (state is OrderEditCartGetProgress) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.cFFC34A));
                  } else if (state is OrderEditCartGetSuccess) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "new_products".tr(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 25.sp,
                              ),
                            ),
                            state.newProducts.isEmpty
                                ? Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "new_products_dialog".tr(),
                                    style: TextStyle(color: Colors.grey, fontSize: 20.sp),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.newProducts.length,
                                  itemBuilder: (context, index) {
                                    return EditOrderItem(
                                      orderProductModel: state.newProducts[index],
                                    );
                                  },
                                ),
                            SizedBox(height: 10.h),
                            Text(
                              "products_on_order".tr(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 25.sp,
                              ),
                            ),
                            state.oldProducts.isEmpty
                                ? Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "products_on_order_dialog".tr(),
                                    style: TextStyle(color: Colors.grey, fontSize: 20.sp),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.oldProducts.length,
                                  itemBuilder: (context, index) {
                                    return EditOrderItem(
                                      orderProductModel: state.oldProducts[index],
                                    );
                                  },
                                ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is OrderEditCartGetFailure) {
                    return Center(child: Text(state.errorText));
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
