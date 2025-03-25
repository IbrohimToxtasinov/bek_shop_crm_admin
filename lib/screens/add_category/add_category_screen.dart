import 'dart:async';
import 'dart:io';
import 'package:bek_shop/blocs/category/category_bloc.dart';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/repositories/category_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/text_fields/custom_text_form_field_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  bool isButtonEnabled = false;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(_checkIfValuesChanged);
  }

  void _checkIfValuesChanged() {
    setState(() {
      isButtonEnabled = textEditingController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
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
          if (state.status == FormStatus.addCategorySuccess) {
            Timer(const Duration(milliseconds: 1000), () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouterNames.tabBoxRoute,
                (route) => false,
              );
            });
          }
          if (state.status == FormStatus.uploadImageCategoryFail ||
              state.status == FormStatus.addCategoryFail) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
        },
        builder: (context, state) {
          return AppUiLoadingContainer(
            loadingText:
                state.status == FormStatus.addCategoryLoading
                    ? "${tr("category_is_being_created")}..."
                    : state.status == FormStatus.uploadImageCategoryLoading
                    ? "${tr("loading_image")}..."
                    : state.status == FormStatus.addCategorySuccess
                    ? "${tr("category_created")}!"
                    : "${tr("image_uploaded")}!",
            isLoading:
                state.status == FormStatus.addCategoryLoading ||
                state.status == FormStatus.uploadImageCategoryLoading ||
                state.status == FormStatus.addCategorySuccess ||
                state.status == FormStatus.uploadImageCategorySuccess,
            child: Scaffold(
              appBar: CustomAppBar(title: "add_category".tr()),
              body: Form(
                key: formGlobalKey,
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
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomTexFormFiledWidget(
                        text: "category_name".tr(),
                        controller: textEditingController,
                        hintText: "enter_category_name".tr(),
                        isSuffixIconHave: true,
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: MainActionButton(
                  onTap: () {
                    if (_image != null) {
                      context.read<CategoryBloc>().add(
                        AddCategory(
                          categoryName: textEditingController.text.trim(),
                          imageFile: _image!,
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

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("${tr("error")}!"),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ok'.tr()),
          ),
        ],
      );
    },
  );
}
