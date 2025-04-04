import 'package:bek_shop/data/models/category/category_model.dart';
import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/screens/add_category/add_category_screen.dart';
import 'package:bek_shop/screens/add_product/add_product_screen.dart';
import 'package:bek_shop/screens/category_details/category_details_screen.dart';
import 'package:bek_shop/screens/category_details/sub_screens/search_products/search_products_screen.dart';
import 'package:bek_shop/screens/category_details/sub_screens/view_product_img/gallery_photo_view_wrapper.dart';
import 'package:bek_shop/screens/create_new_order/create_new_order_screen.dart';
import 'package:bek_shop/screens/edit_order/edit_order_screen.dart';
import 'package:bek_shop/screens/edit_order/sub_screens/products_search_for_edit_order/products_search_screen_for_edit_order.dart';
import 'package:bek_shop/screens/no_internet/no_internet_screen.dart';
import 'package:bek_shop/screens/order_detail/order_detail_screen.dart';
import 'package:bek_shop/screens/splash/splash_screen.dart';
import 'package:bek_shop/screens/tab_box/cart/cart_screen.dart';
import 'package:bek_shop/screens/tab_box/home/home_screen.dart';
import 'package:bek_shop/screens/tab_box/home/sub_screens/global_product_search_screen.dart';
import 'package:bek_shop/screens/tab_box/orders/orders_screen.dart';
import 'package:bek_shop/screens/tab_box/orders/sub_screens/order_search_screen.dart';
import 'package:bek_shop/screens/tab_box/tab_box.dart';
import 'package:bek_shop/screens/update_category/update_category_screen.dart';
import 'package:bek_shop/screens/update_product/update_product_screen.dart';
import 'package:flutter/material.dart';

class AppRouterNames {
  static const String splashRoute = '/';
  static const String tabBoxRoute = "/tab_box";
  static const String homeRoute = "/home";
  static const String cartRoute = "/cart";
  static const String ordersRoute = "/orders";
  static const String orderDetailRoute = "/order_detail";
  static const String categoryDetailsRoute = "/category_details";
  static const String addProductRoute = "/add_product";
  static const String createNewOrder = "/create_new_order";
  static const String addCategoryRoute = "/add_category";
  static const String galleryPhotoViewWrapper = '/gallery_photo_view_wrapper';
  static const String searchProducts = '/search_products';
  static const String searchProductsForEditOrder = '/search_products_for_edit_order';
  static const String searchOrders = '/search_orders';
  static const String globalSearchProducts = '/global_search_products';
  static const String updateProduct = '/update_product';
  static const String updateCategory = '/update_category';
  static const String editOrder = '/edit_order';
  static const String noInternetRoute = '/no_internet_route';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouterNames.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRouterNames.noInternetRoute:
        return MaterialPageRoute(
          builder: (_) => NoInternetScreen(voidCallback: settings.arguments as VoidCallback),
        );
      case AppRouterNames.globalSearchProducts:
        return MaterialPageRoute(builder: (_) => const GlobalProductSearchScreen());
      case AppRouterNames.searchProductsForEditOrder:
        return MaterialPageRoute(builder: (_) => const ProductsSearchScreenForEditOrder());
      case AppRouterNames.searchOrders:
        return MaterialPageRoute(builder: (_) => const OrderSearchScreen());
      case AppRouterNames.editOrder:
        return MaterialPageRoute(
          builder: (_) => EditOrderScreen(orderModel: settings.arguments as OrderModel),
        );
      case AppRouterNames.createNewOrder:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => CreateNewOrderScreen(
                addressName: args["addressName"],
                latLongModel: args["latLongModel"],
                products: args["products"],
              ),
        );
      case AppRouterNames.tabBoxRoute:
        return MaterialPageRoute(builder: (_) => const TabBox());
      case AppRouterNames.searchProducts:
        return MaterialPageRoute(
          builder: (_) => SearchProductsScreen(categoryId: settings.arguments as String),
        );
      case AppRouterNames.galleryPhotoViewWrapper:
        return MaterialPageRoute(
          builder: (_) => GalleryPhotoViewWrapper(productImage: settings.arguments as String),
        );
      case AppRouterNames.cartRoute:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRouterNames.ordersRoute:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case AppRouterNames.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case AppRouterNames.updateProduct:
        return MaterialPageRoute(
          builder: (_) => UpdateProductScreen(productModel: settings.arguments as ProductModel),
        );
      case AppRouterNames.updateCategory:
        return MaterialPageRoute(
          builder: (_) => UpdateCategoryScreen(categoryModel: settings.arguments as CategoryModel),
        );
      case AppRouterNames.orderDetailRoute:
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderModel: settings.arguments as OrderModel),
        );
      case AppRouterNames.categoryDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => CategoryDetailsScreen(categoryModel: settings.arguments as CategoryModel),
        );
      case AppRouterNames.addCategoryRoute:
        return MaterialPageRoute(builder: (_) => const AddCategoryScreen());
      case AppRouterNames.addProductRoute:
        return MaterialPageRoute(
          builder: (_) => AddProductScreen(categoryId: settings.arguments as String),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(body: Center(child: Text('No route defined for ${settings.name}')));
          },
        );
    }
  }
}
