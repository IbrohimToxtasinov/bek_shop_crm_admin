import 'package:bek_shop/blocs/order_search/order_search_bloc.dart';
import 'package:bek_shop/screens/tab_box/orders/widgets/order_item.dart';
import 'package:bek_shop/screens/widgets/text_fields/app_search_text_field.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderSearchScreen extends StatefulWidget {
  const OrderSearchScreen({super.key});

  @override
  State<OrderSearchScreen> createState() => _OrderSearchScreenState();
}

class _OrderSearchScreenState extends State<OrderSearchScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchFocusNode.requestFocus();
    BlocProvider.of<OrderSearchBloc>(context).add(SearchOrders(clientName: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        return AppSearchTextField(
                          color: AppColors.cF8F8F8,
                          hint: "search".tr(),
                          prefixTap: () => searchController.clear(),
                          focusNode: searchFocusNode,
                          onChanged: (value) {
                            BlocProvider.of<OrderSearchBloc>(
                              context,
                            ).add(SearchOrders(clientName: value));
                          },
                          controller: searchController,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 7),
                  SizedBox(
                    height: 50,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              "cancel".tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<OrderSearchBloc, OrderSearchState>(
                buildWhen: (previous, current) => current is SearchOrdersSuccess,
                builder: (context, state) {
                  if (state is SearchOrdersLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.cFFC34A));
                  } else if (state is SearchOrdersSuccess) {
                    return state.orders.isNotEmpty
                        ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                child: Text(
                                  tr('order_items_found', args: [state.orders.length.toString()]),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c101828,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.orders.length,
                                itemBuilder: (context, index) {
                                  return OrderItem(orderModel: state.orders[index]);
                                },
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        )
                        : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 150),
                              SvgPicture.asset(AppIcons.emptySearch, height: 150.h, width: 200.w),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                                child: Text(
                                  tr('order_items_found', args: [state.orders.length.toString()]),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c101828,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                  } else if (state is SearchOrdersFailure) {
                    return Center(child: Text(state.errorText));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
