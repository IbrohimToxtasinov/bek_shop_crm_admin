import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/order_edit_cart/order_edit_cart_bloc.dart';
import 'package:bek_shop/blocs/search_products/search_products_bloc.dart';
import 'package:bek_shop/screens/category_details/widgets/total_cost_button.dart';
import 'package:bek_shop/screens/edit_order/sub_screens/products_search_for_edit_order/widgets/product_item_for_edit.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/text_fields/app_search_text_field.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductsSearchScreenForEditOrder extends StatefulWidget {
  const ProductsSearchScreenForEditOrder({super.key});

  @override
  State<ProductsSearchScreenForEditOrder> createState() => _ProductsSearchScreenForEditOrderState();
}

class _ProductsSearchScreenForEditOrderState extends State<ProductsSearchScreenForEditOrder> {
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
    BlocProvider.of<SearchProductsBloc>(context).add(GlobalSearchProducts(productName: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BlocBuilder<OrderEditCartBloc, OrderEditCartState>(
        buildWhen: (previous, current) => current is OrderEditCartGetSuccess,
        builder: (context, state) {
          return AnimatedContainer(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 100),
            height: [...state.newProducts, ...state.oldProducts].isNotEmpty ? 85.h : 0.h,
            width: double.infinity,
            padding: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.r),
                topLeft: Radius.circular(25.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.r,
                  blurRadius: 10.r,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.r),
                topLeft: Radius.circular(25.r),
              ),
              child: Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(15.w),
                child: TotalCostButton(
                  productCount: AppUtils.cartProductsLengthForEdit([
                    ...state.newProducts,
                    ...state.oldProducts,
                  ]),
                  totalCost: AppUtils.totalPriceForEdit([
                    ...state.newProducts,
                    ...state.oldProducts,
                  ]),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
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
                            BlocProvider.of<SearchProductsBloc>(
                              context,
                            ).add(GlobalSearchProducts(productName: value));
                          },
                          controller: searchController,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 7.w),
                  SizedBox(
                    height: 50.h,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(width: 5.w),
                            Text(
                              "cancel".tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 5.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchProductsBloc, SearchProductsState>(
                buildWhen: (previous, current) => current is GlobalSearchProductsSuccess,
                builder: (context, state) {
                  if (state is GlobalSearchProductsLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.cFFC34A));
                  } else if (state is GlobalSearchProductsSuccess) {
                    return state.products.isNotEmpty
                        ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                                child: Text(
                                  tr('items_found', args: [state.products.length.toString()]),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c101828,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.products.length,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0.h,
                                  crossAxisSpacing: 10.0.w,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width > 600 ? 0.8 : 0.67,
                                ),
                                itemBuilder: (context, index) {
                                  return ProductItemForEdit(
                                    onTap: () => searchFocusNode.unfocus(),
                                    productModel: state.products[index],
                                  );
                                },
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        )
                        : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 150.h),
                              SvgPicture.asset(AppIcons.emptySearch, height: 150.h, width: 200.w),
                              Padding(
                                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h),
                                child: Text(
                                  tr('items_found', args: [state.products.length.toString()]),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c101828,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                  } else if (state is GlobalSearchProductsFailure) {
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
