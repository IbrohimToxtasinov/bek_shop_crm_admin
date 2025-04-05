import 'dart:async';
import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/order/order_bloc.dart';
import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/data/models/lat_long/lat_long_model.dart';
import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/screens/add_category/add_category_screen.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:bek_shop/screens/widgets/app_bar/custom_appbar.dart';
import 'package:bek_shop/screens/widgets/buttons/main_action_button.dart';
import 'package:bek_shop/screens/widgets/containers/app_ui_loading_container.dart';
import 'package:bek_shop/screens/widgets/overlay/overlays.dart';
import 'package:bek_shop/screens/widgets/text_fields/app_phone_text_field.dart';
import 'package:bek_shop/screens/widgets/text_fields/custom_text_form_field_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateNewOrderScreen extends StatefulWidget {
  final String? addressName;
  final LatLongModel latLongModel;
  final List<CartModel> products;

  const CreateNewOrderScreen({
    super.key,
    required this.products,
    this.addressName,
    required this.latLongModel,
  });

  @override
  State<CreateNewOrderScreen> createState() => _CreateNewOrderScreenState();
}

class _CreateNewOrderScreenState extends State<CreateNewOrderScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  String phoneText = '';
  FocusNode phoneFocusNode = FocusNode();
  TextEditingController phoneController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();

  @override
  void initState() {
    if (widget.addressName != null) {
      addressNameController.text = widget.addressName!;
    }
    super.initState();
  }

  @override
  void dispose() {
    clientNameController.dispose();
    addressNameController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return OrderBloc(context.read<OrderRepository>(), context.read<ProductRepository>());
      },
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is CreateOrderInFailure) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
          if (state is UpdateProductInFailure) {
            showErrorDialog(context, "${tr("error_occurred")}!");
          }
          if (state is UpdateProductLoadInSuccess) {
            BlocProvider.of<CartBloc>(context).add(DeleteCart());
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
            loadingText:
                state is CreateOrderLoadInProgress
                    ? "${tr("creating_order")}..."
                    : state is CreateOrderLoadInSuccess
                    ? "${tr("order_created")}!"
                    : state is UpdateProductLoadInProgress
                    ? "${tr("products_update_database")}..."
                    : "${tr("products_updated_success")}!",
            isLoading:
                state is CreateOrderLoadInProgress ||
                state is CreateOrderLoadInSuccess ||
                state is UpdateProductLoadInProgress ||
                state is UpdateProductLoadInSuccess,
            child: Scaffold(
              bottomNavigationBar: Padding(
                padding:  EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 20.h),
                child: MainActionButton(
                  label: "create".tr(),
                  onTap: () {
                    if (formGlobalKey.currentState != null &&
                        formGlobalKey.currentState!.validate()) {
                      formGlobalKey.currentState!.save();
                      if (phoneText.length == 19) {
                        context.read<OrderBloc>().add(
                          CreateOrder(
                            clientName: clientNameController.text.trim(),
                            clientPhoneNumber: phoneText.trim(),
                            clientAddress: addressNameController.text.trim(),
                            products: widget.products,
                            latLong: widget.latLongModel,
                          ),
                        );
                        FocusScope.of(context).unfocus();
                      } else {
                        showOverlayMessage(context, text: "enter_correct_client_phone_number".tr());
                      }
                    }
                  },
                ),
              ),
              appBar: CustomAppBar(title: "create_new_order".tr()),
              body: Form(
                key: formGlobalKey,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      CustomTexFormFiledWidget(
                        text: "client_name".tr(),
                        controller: clientNameController,
                        hintText: 'enter_client_name'.tr(),
                        validator:
                            (username) =>
                                username != null && username.isEmpty
                                    ? 'enter_client_name'.tr()
                                    : null,
                      ),
                      SizedBox(height: 24.h),
                      AppPhoneTextField(
                        onChanged: (text) {
                          phoneText = text;
                          if (text.length == 19) {
                            phoneFocusNode.unfocus();
                          }
                        },
                        enabled: true,
                        focusNode: phoneFocusNode,
                      ),
                      SizedBox(height: 24.h),
                      CustomTexFormFiledWidget(
                        isSuffixIconHave: true,
                        controller: addressNameController,
                        text: 'client_address'.tr(),
                        hintText: 'enter_client_address'.tr(),
                        validator:
                            (address) =>
                                address != null && address.isEmpty
                                    ? "enter_client_address".tr()
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
