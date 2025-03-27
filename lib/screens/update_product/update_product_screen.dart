import 'dart:async';
import 'package:bek_shop/blocs/product/product_bloc.dart';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bek_shop/screens/add_category/add_category_screen.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/dialogs/delete_dialog.dart';
import 'package:bek_shop/screens/widgets/images/app_cached_network_image.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/screens/widgets/text_fields/custom_text_form_field_widget.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:bek_shop/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductModel productModel;

  const UpdateProductScreen({super.key, required this.productModel});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  TextEditingController productNameTextEditingController = TextEditingController();
  TextEditingController productDescriptionTextEditingController = TextEditingController();
  TextEditingController productPriceTextEditingController = TextEditingController();
  TextEditingController productQuantityTextEditingController = TextEditingController();
  bool isButtonEnabled = false;
  bool productActive = true;
  bool isCountable = true;
  DateTime? mfgDate;
  DateTime? expDate;

  @override
  void initState() {
    super.initState();
    productNameTextEditingController.text = widget.productModel.productName;
    productDescriptionTextEditingController.text = widget.productModel.productDescription;
    productPriceTextEditingController.text = widget.productModel.productPrice.toInt().toString();
    productQuantityTextEditingController.text =
        widget.productModel.productQuantity.toInt().toString();
    productActive = widget.productModel.productActive;
    isCountable = widget.productModel.isCountable;
    if (widget.productModel.mfgDate != null && widget.productModel.mfgDate!.isNotEmpty) {
      mfgDate = DateTime.parse(widget.productModel.mfgDate!);
    }
    if (widget.productModel.expDate != null && widget.productModel.expDate!.isNotEmpty) {
      expDate = DateTime.parse(widget.productModel.expDate!);
    }
    productNameTextEditingController.addListener(_checkIfValuesChanged);
    productDescriptionTextEditingController.addListener(_checkIfValuesChanged);
    productPriceTextEditingController.addListener(_checkIfValuesChanged);
    productQuantityTextEditingController.addListener(_checkIfValuesChanged);
  }

  @override
  void dispose() {
    productNameTextEditingController.dispose();
    productDescriptionTextEditingController.dispose();
    productPriceTextEditingController.dispose();
    productQuantityTextEditingController.dispose();
    super.dispose();
  }

  void _checkIfValuesChanged() {
    bool fieldsNotEmpty =
        productNameTextEditingController.text.isNotEmpty &&
        productDescriptionTextEditingController.text.isNotEmpty &&
        productPriceTextEditingController.text.isNotEmpty &&
        productQuantityTextEditingController.text.isNotEmpty;

    bool valuesChanged =
        productNameTextEditingController.text != widget.productModel.productName ||
        productDescriptionTextEditingController.text != widget.productModel.productDescription ||
        productPriceTextEditingController.text != widget.productModel.productPrice.toString() ||
        productQuantityTextEditingController.text != widget.productModel.productQuantity.toString();
    setState(() {
      isButtonEnabled = valuesChanged && fieldsNotEmpty;
    });
  }

  Widget _buildUnitSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("product_unit".tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: "dona", label: Text("piece".tr())),
            ButtonSegment(value: "kg", label: Text("kg".tr())),
          ],
          selected: {isCountable ? "dona" : "kg"},
          onSelectionChanged: (newValue) {
            setState(() {
              isCountable = newValue.first == "dona";
              isButtonEnabled = isCountable != widget.productModel.isCountable;
            });
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        onDateSelected(pickedDate);
        isButtonEnabled =
            mfgDate.toString() != widget.productModel.mfgDate ||
            expDate.toString() != widget.productModel.expDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductBloc(
          context.read<ProductRepository>(),
          context.read<UploadImageRepository>(),
        );
      },
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.status == FormStatus.deleteProductSuccess) {
            showOverlayMessage(
              context,
              text: "product_successfully_deleted".tr(),
              status: OverlayStatus.success,
            );
            Navigator.pop(context);
          }
          if (state.status == FormStatus.updateProductSuccess) {
            Timer(const Duration(milliseconds: 1000), () => Navigator.pop(context));
          }
          if (state.status == FormStatus.updateProductFail ||
              state.status == FormStatus.deleteProductFail) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
        },
        builder: (context, state) {
          return AppUiLoadingContainer(
            loadingText:
                state.status == FormStatus.updateProductLoading
                    ? "${tr("product_being_updated")}..."
                    : state.status == FormStatus.updateProductSuccess
                    ? "${tr("product_updated")}!"
                    : null,
            isLoading:
                state.status == FormStatus.updateProductLoading ||
                state.status == FormStatus.updateProductSuccess,
            child: Scaffold(
              appBar: CustomAppBar(
                title: "update_product".tr(),
                showTrailing: true,
                trailing: IconButton(
                  tooltip: "delete_product",
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
                              context.read<ProductBloc>().add(
                                DeleteProduct(productId: widget.productModel.productId),
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
              body: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppCachedNetworkImage(
                        image: widget.productModel.productImage,
                        width: double.infinity,
                        height: 250,
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            CustomTexFormFiledWidget(
                              text: "product_name".tr(),
                              controller: productNameTextEditingController,
                              hintText: "enter_product_name".tr(),
                              isSuffixIconHave: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 10.h),
                            CustomTexFormFiledWidget(
                              text: "product_description".tr(),
                              controller: productDescriptionTextEditingController,
                              hintText: "enter_product_description".tr(),
                              isSuffixIconHave: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 10.h),
                            CustomTexFormFiledWidget(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              text: "product_price".tr(),
                              controller: productPriceTextEditingController,
                              hintText: "enter_product_price".tr(),
                              isSuffixIconHave: true,
                            ),
                            SizedBox(height: 10.h),
                            CustomTexFormFiledWidget(
                              keyboardType: TextInputType.number,
                              text: "product_quantity".tr(),
                              controller: productQuantityTextEditingController,
                              hintText: "enter_product_quantity".tr(),
                              isSuffixIconHave: true,
                            ),
                            SizedBox(height: 5.h),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "product_activity".tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.c101426,
                                ),
                              ),
                              value: productActive,
                              onChanged: (value) {
                                setState(() {
                                  productActive = value;
                                  isButtonEnabled =
                                      productActive != widget.productModel.productActive;
                                });
                              },
                            ),
                            _buildUnitSelector(),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "production_date".tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.c101426,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    mfgDate != null
                                        ? mfgDate!.toLocal().toString().split(' ')[0]
                                        : "select_date".tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        mfgDate = null;
                                        if (expDate != null) {
                                          isButtonEnabled = true;
                                        }
                                      });
                                    },
                                    icon: SvgPicture.asset(AppIcons.clear),
                                  ),
                                ],
                              ),
                              onTap: () => _selectDate(context, (date) => mfgDate = date),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "expiration_date".tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.c101426,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    expDate != null
                                        ? expDate!.toLocal().toString().split(' ')[0]
                                        : "select_date".tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        expDate = null;
                                        if (expDate != null) {
                                          isButtonEnabled = true;
                                        }
                                      });
                                    },
                                    icon: SvgPicture.asset(AppIcons.clear),
                                  ),
                                ],
                              ),
                              onTap: () => _selectDate(context, (date) => expDate = date),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: MainActionButton(
                  onTap: () {
                    context.read<ProductBloc>().add(
                      UpdateProduct(
                        productModel: ProductModel(
                          mfgDate: mfgDate?.toString() ?? "",
                          expDate: expDate?.toString() ?? "",
                          categoryId: widget.productModel.categoryId,
                          productId: widget.productModel.productId,
                          productName: productNameTextEditingController.text.trim(),
                          productPrice: double.parse(
                            productPriceTextEditingController.text
                                .trim()
                                .replaceAll(" ", "")
                                .toString(),
                          ),
                          productActive: productActive,
                          productImage: widget.productModel.productImage,
                          productQuantity: double.parse(
                            productQuantityTextEditingController.text
                                .trim()
                                .replaceAll(" ", "")
                                .toString(),
                          ),
                          createdAt: widget.productModel.createdAt,
                          productDescription: productDescriptionTextEditingController.text.trim(),
                          isCountable: isCountable,
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
