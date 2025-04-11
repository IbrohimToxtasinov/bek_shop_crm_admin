import 'package:bek_shop/blocs/category/category_bloc.dart';
import 'package:bek_shop/blocs/product/product_bloc.dart';
import 'package:bek_shop/blocs/products_pdf/products_pdf_bloc.dart';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/models/category/category_model.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:bek_shop/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsPdfBloc(context.read<ProductRepository>()),
      child: BlocConsumer<ProductsPdfBloc, ProductsPdfState>(
        listener: (context, pdfState) {
          if (pdfState is ProductsPdfError) {
            showOverlayMessage(context, text: pdfState.message);
          }
        },
        builder: (context, pdfState) {
          return AppUiLoadingContainer(
            isLoading: pdfState is ProductsPdfLoading || pdfState is ProductsPdfGenerated,
            loadingText:
                pdfState is ProductsPdfLoading
                    ? "${tr("creating_pdf")}..."
                    : pdfState is ProductsPdfGenerated
                    ? "${tr("pdf_file_created")}!"
                    : null,
            child: Scaffold(
              appBar: CustomAppBar(
                centerTitle: false,
                title: "categories".tr(),
                showTrailing: true,
                trailing: Row(
                  children: [
                    IconButton(
                      tooltip: "search".tr(),
                      icon: SvgPicture.asset(
                        AppIcons.search,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      ),
                      onPressed:
                          () => Navigator.pushNamed(context, AppRouterNames.globalSearchProducts),
                    ),
                    IconButton(
                      tooltip: "add_category".tr(),
                      onPressed:
                          () => Navigator.pushNamed(context, AppRouterNames.addCategoryRoute),
                      icon: SvgPicture.asset(AppIcons.add, width: 24.w, height: 24.h),
                    ),
                    IconButton(
                      tooltip: "download".tr(),
                      icon: SvgPicture.asset(AppIcons.download, width: 24.w, height: 24.h),
                      onPressed: () {
                        context.read<ProductsPdfBloc>().add(GenerateAndSharePdfEvent(share: false));
                      },
                    ),
                    IconButton(
                      tooltip: "share".tr(),
                      icon: SvgPicture.asset(AppIcons.share, width: 24.w, height: 24.h),
                      onPressed: () {
                        context.read<ProductsPdfBloc>().add(GenerateAndSharePdfEvent(share: true));
                      },
                    ),
                  ],
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state.status == FormStatus.categoryLoading) {
                        return Center(child: CircularProgressIndicator(color: AppColors.cFFC34A));
                      } else if (state.status == FormStatus.categorySuccess) {
                        if (state.categories.isNotEmpty) {
                          return Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              itemCount: state.categories.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 10.w,
                                childAspectRatio:
                                    MediaQuery.of(context).size.width > 600 ? 1 : 0.85,
                              ),
                              itemBuilder: (context, index) {
                                return FruitsAndVegetablesCard(
                                  categoryModel: state.categories[index],
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16).w,
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
                      } else if (state.status == FormStatus.categoryFail) {
                        return Center(child: Text(state.errorMessage));
                      } else {
                        return Center(child: Text("some_error".tr()));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FruitsAndVegetablesCard extends StatelessWidget {
  final CategoryModel categoryModel;

  const FruitsAndVegetablesCard({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.grey.shade300,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onLongPress: () {
          Navigator.pushNamed(context, AppRouterNames.updateCategory, arguments: categoryModel);
        },
        onTap: () {
          context.read<ProductBloc>().add(
            FetchProductByCategoryId(categoryId: categoryModel.categoryId),
          );
          Navigator.pushNamed(
            context,
            AppRouterNames.categoryDetailsRoute,
            arguments: categoryModel,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                topLeft: Radius.circular(20.r),
              ),
              child: AppCachedNetworkImage(
                height: 150.h,
                width: double.infinity,
                image: categoryModel.categoryImage,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              child: Text(
                overflow: TextOverflow.ellipsis,
                categoryModel.categoryName,
                maxLines: 2,
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
