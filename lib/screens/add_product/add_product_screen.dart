import 'dart:async';
import 'dart:io';
import 'package:bek_shop/blocs/product/product_bloc.dart';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/text_fields/custom_text_form_field_widget.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../add_category/add_category_screen.dart';

class AddProductScreen extends StatefulWidget {
  final String categoryId;

  const AddProductScreen({super.key, required this.categoryId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameTextEditingController = TextEditingController();
  TextEditingController productDescriptionTextEditingController = TextEditingController();
  TextEditingController productPriceTextEditingController = TextEditingController();
  TextEditingController productQuantityTextEditingController = TextEditingController();
  bool isButtonEnabled = false;
  File? _image;
  bool productActive = true;
  bool isCountable = true;
  DateTime? mfgDate;
  DateTime? expDate;

  @override
  void initState() {
    super.initState();
    productNameTextEditingController.addListener(_validateForm);
    productDescriptionTextEditingController.addListener(_validateForm);
    productPriceTextEditingController.addListener(_validateForm);
    productQuantityTextEditingController.addListener(_validateForm);
  }

  @override
  void dispose() {
    productNameTextEditingController.dispose();
    productDescriptionTextEditingController.dispose();
    productPriceTextEditingController.dispose();
    productQuantityTextEditingController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled =
          productNameTextEditingController.text.isNotEmpty &&
          productDescriptionTextEditingController.text.isNotEmpty &&
          productPriceTextEditingController.text.isNotEmpty &&
          productQuantityTextEditingController.text.isNotEmpty &&
          _image != null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _validateForm();
      });
    }
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
          if (state.status == FormStatus.addProductSuccess) {
            Timer(const Duration(milliseconds: 1000), () => Navigator.pop(context));
          }
          if (state.status == FormStatus.uploadImageProductFail ||
              state.status == FormStatus.addProductFail) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
        },
        builder: (context, state) {
          return AppUiLoadingContainer(
            loadingText:
                state.status == FormStatus.addProductLoading
                    ? "${tr("adding_product")}..."
                    : state.status == FormStatus.uploadImageProductLoading
                    ? "${tr("loading_image")}..."
                    : state.status == FormStatus.addProductSuccess
                    ? "${tr("product_added")}!"
                    : "${tr("image_uploaded")}!",
            isLoading:
                state.status == FormStatus.addProductLoading ||
                state.status == FormStatus.uploadImageProductLoading ||
                state.status == FormStatus.addProductSuccess ||
                state.status == FormStatus.uploadImageProductSuccess,
            child: Scaffold(
              appBar: CustomAppBar(title: "add_product".tr()),
              body: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 250.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image:
                              _image != null
                                  ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                                  : null,
                          color: Colors.grey[300],
                        ),
                        child:
                            _image == null
                                ? Center(
                                  child: IconButton(
                                    onPressed: _pickImage,
                                    icon: Icon(Icons.upload, size: 40, color: Colors.black54),
                                  ),
                                )
                                : Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Positioned.fill(child: Image.file(_image!, fit: BoxFit.cover)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        child: IconButton(
                                          icon: Icon(Icons.edit, color: Colors.white),
                                          onPressed: _pickImage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
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
                              trailing: Text(
                                mfgDate != null
                                    ? mfgDate!.toLocal().toString().split(' ')[0]
                                    : "select_date".tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade700,
                                ),
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
                              trailing: Text(
                                expDate != null
                                    ? expDate!.toLocal().toString().split(' ')[0]
                                    : "select_date".tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue.shade700,
                                ),
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
                    if (_image != null) {
                      context.read<ProductBloc>().add(
                        AddProduct(
                          productActive: productActive,
                          isCountable: isCountable,
                          mfgDate: mfgDate?.toString() ?? "",
                          expDate: expDate?.toString() ?? "",
                          imageFile: _image!,
                          categoryId: widget.categoryId,
                          productName: productNameTextEditingController.text.trim(),
                          productPrice: double.parse(productPriceTextEditingController.text.trim()),
                          productQuantity: double.parse(
                            productQuantityTextEditingController.text.trim(),
                          ),
                          productDescription: productDescriptionTextEditingController.text.trim(),
                        ),
                      );
                    } else {
                      showErrorDialog(context, "${tr("please_upload_image")}!");
                    }
                  },
                  enabled: isButtonEnabled,
                  label: "save".tr(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
