import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/product/product_bloc.dart';
import 'package:bek_shop/blocs/products_pdf/products_pdf_bloc.dart';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/models/category/category_model.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/screens/category_details/widgets/product_item.dart';
import 'package:bek_shop/screens/category_details/widgets/total_cost_button.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:bek_shop/utils/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const CategoryDetailsScreen({super.key, required this.categoryModel});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsPdfBloc(context.read<ProductRepository>()),
      child: BlocConsumer<ProductsPdfBloc, ProductsPdfState>(
        listener: (context, pdfState) {
          if (pdfState is CategoryProductsPdfError) {
            showOverlayMessage(context, text: pdfState.message);
          }
        },
        builder: (context, pdfState) {
          return AppUiLoadingContainer(
            isLoading:
                pdfState is CategoryProductsPdfLoading ||
                pdfState is CategoryProductsPdfGenerated,
            loadingText:
                pdfState is CategoryProductsPdfLoading
                    ? "${tr("creating_pdf")}..."
                    : pdfState is CategoryProductsPdfGenerated
                    ? "${tr("pdf_file_created")}!"
                    : null,
            child: Scaffold(
              appBar: CustomAppBar(
                title: widget.categoryModel.categoryName,
                showTrailing: true,
                centerTitle: false,
                trailing: Row(
                  children: [
                    IconButton(
                      tooltip: "search".tr(),
                      icon: SvgPicture.asset(
                        AppIcons.search,
                        height: 24.h,
                        width: 24.w,
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterNames.searchProducts,
                          arguments: widget.categoryModel.categoryId,
                        );
                      },
                    ),
                    IconButton(
                      tooltip: "add_product".tr(),
                      icon: SvgPicture.asset(
                        AppIcons.add,
                        height: 24.h,
                        width: 24.w,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterNames.addProductRoute,
                          arguments: widget.categoryModel.categoryId,
                        );
                      },
                    ),
                    IconButton(
                      tooltip: "download".tr(),
                      icon: SvgPicture.asset(
                        AppIcons.download,
                        width: 24.w,
                        height: 24.h,
                      ),
                      onPressed: () {
                        context.read<ProductsPdfBloc>().add(
                          GenerateAndSharePdfForCategoryEvent(
                            share: false,
                            categoryId: widget.categoryModel.categoryId,
                            categoryName: widget.categoryModel.categoryName,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: "share".tr(),
                      icon: SvgPicture.asset(
                        AppIcons.share,
                        width: 24.w,
                        height: 24.h,
                      ),
                      onPressed: () {
                        context.read<ProductsPdfBloc>().add(
                          GenerateAndSharePdfForCategoryEvent(
                            share: true,
                            categoryId: widget.categoryModel.categoryId,
                            categoryName: widget.categoryModel.categoryName,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.status == FormStatus.productLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cFFC34A,
                      ),
                    );
                  } else if (state.status == FormStatus.productSuccess) {
                    if (state.products.isNotEmpty) {
                      return GridView.builder(
                        itemCount: state.products.length,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0.h,
                          crossAxisSpacing: 10.0.w,
                          childAspectRatio:
                              MediaQuery.of(context).size.width > 600
                                  ? 0.8
                                  : 0.67,
                        ),
                        itemBuilder:
                            (context, index) => ProductItem(
                              productModel: state.products[index],
                            ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              Lottie.asset(AppImages.emptyBox, repeat: false),
                              SizedBox(height: 24.h),
                              Text(
                                "empty_cart".tr(),
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  color: AppColors.c101426,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else if (state.status == FormStatus.productFail) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return Center(child: Text("some_error".tr()));
                  }
                },
              ),
              bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
                buildWhen:
                    (previous, current) => current is CartLoadInSuccessGet,
                builder: (context, state) {
                  return AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                    height: state.products.isNotEmpty ? 85.h : 0.h,
                    width: double.infinity.w,
                    padding: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
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
                        width: double.infinity.w,
                        color: Colors.white,
                        padding: EdgeInsets.all(15.w),
                        child: TotalCostButton(
                          productCount: AppUtils.cartProductsLength(
                            state.products,
                          ),
                          totalCost: AppUtils.totalPrice(state.products),
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRouterNames.cartRoute,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
