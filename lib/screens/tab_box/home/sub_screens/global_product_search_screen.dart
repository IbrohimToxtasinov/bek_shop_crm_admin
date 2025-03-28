import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/search_products/search_products_bloc.dart';
import 'package:bek_shop/screens/category_details/widgets/product_item.dart';
import 'package:bek_shop/screens/category_details/widgets/total_cost_button.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/text_fields/app_search_text_field.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlobalProductSearchScreen extends StatefulWidget {
  const GlobalProductSearchScreen({super.key});

  @override
  State<GlobalProductSearchScreen> createState() => _GlobalProductSearchScreenState();
}

class _GlobalProductSearchScreenState extends State<GlobalProductSearchScreen> {
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
                            BlocProvider.of<SearchProductsBloc>(
                              context,
                            ).add(GlobalSearchProducts(productName: value));
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
              child: BlocBuilder<SearchProductsBloc, SearchProductsState>(
                buildWhen: (previous, current) => current is GlobalSearchProductsSuccess,
                builder: (context, state) {
                  if (state is GlobalSearchProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GlobalSearchProductsSuccess) {
                    return state.products.isNotEmpty
                        ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                child: Text(
                                  tr('items_found', args: [state.products.length.toString()]),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c101828,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.products.length,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio:MediaQuery.of(context).size.width > 600 ? 0.9 : 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  return ProductItem(
                                    onTap: () => searchFocusNode.unfocus(),
                                    productModel: state.products[index],
                                  );
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
                                  tr('items_found', args: [state.products.length.toString()]),
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
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) => current is CartLoadInSuccessGet,
        builder: (context, state) {
          return AnimatedContainer(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 100),
            height: state.products.isNotEmpty ? 85.h : 0,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
              child: Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: TotalCostButton(
                  productCount: AppUtils.cartProductsLength(state.products),
                  totalCost: AppUtils.totalPrice(state.products),
                  onTap: () => Navigator.pushNamed(context, AppRouterNames.cartRoute),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
