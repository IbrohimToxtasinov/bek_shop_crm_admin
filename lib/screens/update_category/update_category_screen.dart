import 'dart:async';
import 'package:bek_shop/blocs/category/category_bloc.dart';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/models/category/category_model.dart';
import 'package:bek_shop/data/repositories/category_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/dialogs/delete_dialog.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/text_fields/custom_text_form_field_widget.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../add_category/add_category_screen.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const UpdateCategoryScreen({super.key, required this.categoryModel});

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  TextEditingController categoryNameTextEditingController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    categoryNameTextEditingController.text = widget.categoryModel.categoryName;
    categoryNameTextEditingController.addListener(_checkIfValuesChanged);
  }

  @override
  void dispose() {
    categoryNameTextEditingController.dispose();
    super.dispose();
  }

  void _checkIfValuesChanged() {
    bool fieldsNotEmpty = categoryNameTextEditingController.text.isNotEmpty;
    bool valuesChanged =
        categoryNameTextEditingController.text != widget.categoryModel.categoryName;
    setState(() {
      isButtonEnabled = valuesChanged && fieldsNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CategoryBloc(
            context.read<CategoryRepository>(),
            context.read<UploadImageRepository>(),
          ),
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.status == FormStatus.deleteCategorySuccess) {
            Navigator.pop(context);
          }
          if (state.status == FormStatus.updateCategorySuccess) {
            Timer(const Duration(milliseconds: 1000), () => Navigator.pop(context));
          }
          if (state.status == FormStatus.deleteCategoryFail ||
              state.status == FormStatus.updateCategoryFail) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
        },
        builder: (context, state) {
          return AppUiLoadingContainer(
            loadingText:
                state.status == FormStatus.updateCategoryLoading
                    ? "${tr("category_being_updated")}..."
                    : state.status == FormStatus.updateCategorySuccess
                    ? "${tr("category_updated")}!"
                    : null,
            isLoading:
                state.status == FormStatus.updateCategoryLoading ||
                state.status == FormStatus.updateCategorySuccess,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBar(
                title: "update_category".tr(),
                showTrailing: true,
                trailing: IconButton(
                  tooltip: "delete_category".tr(),
                  icon: SvgPicture.asset(
                    AppIcons.deleteBold,
                    colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: DeleteDialog(
                            text: "delete_product_cart".tr(),
                            onTap: () {
                              context.read<CategoryBloc>().add(
                                DeleteCategory(categoryId: widget.categoryModel.categoryId),
                              );
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              body: Column(
                children: [
                  AppCachedNetworkImage(
                    image: widget.categoryModel.categoryImage,
                    width: double.infinity,
                    height: 250.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: CustomTexFormFiledWidget(
                      text: "category_name".tr(),
                      controller: categoryNameTextEditingController,
                      hintText: "enter_category_name".tr(),
                      isSuffixIconHave: true,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: MainActionButton(
                  onTap: () {
                    context.read<CategoryBloc>().add(
                      UpdateCategory(
                        categoryModel: CategoryModel(
                          categoryId: widget.categoryModel.categoryId,
                          createdAt: widget.categoryModel.createdAt,
                          categoryName: categoryNameTextEditingController.text.trim(),
                          categoryImage: widget.categoryModel.categoryImage,
                        ),
                      ),
                    );
                  },
                  enabled: isButtonEnabled,
                  label: "update".tr(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
