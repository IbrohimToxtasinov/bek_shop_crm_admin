import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:easy_localization/easy_localization.dart';

class AppUtils {
  const AppUtils._();

  static String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${getFormattedTime(parsedDate)} ${parsedDate.formatDateTime("HH:mm")}';
  }

  static String formatProductDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return getFormattedTime(parsedDate);
  }

  static String totalPriceFormatter(List<CartModel> products) {
    num sum = 0;
    for (int i = 0; i < products.length; i++) {
      sum = sum + products[i].productPrice * products[i].count;
    }
    return sum.toString();
  }

  static num totalPrice(List<CartModel> products) {
    num sum = 0;
    for (int i = 0; i < products.length; i++) {
      sum = sum + products[i].productPrice * products[i].count;
    }
    return sum;
  }

  static String cartProductsLength(List<CartModel> products) {
    num sum = 0;
    for (int i = 0; i < products.length; i++) {
      sum = sum + products[i].count;
    }
    return sum.toString();
  }

  static String getFormattedTime(DateTime dateTime) {
    final nameMonth = dateTime.getMonthName();
    return '${dateTime.day} $nameMonth ${"${dateTime.year} ${tr("year")} "}';
  }
}

extension AppDateTimeExtension on DateTime {
  String getMonthName() {
    switch (month) {
      case 1:
        return "january".tr();
      case 2:
        return "february".tr();
      case 3:
        return "march".tr();
      case 4:
        return "april".tr();
      case 5:
        return "may".tr();
      case 6:
        return "june".tr();
      case 7:
        return "july".tr();
      case 8:
        return "august".tr();
      case 9:
        return "september".tr();
      case 10:
        return "october".tr();
      case 11:
        return "november".tr();
      case 12:
        return "december".tr();
      default:
        return "invalid_month".tr();
    }
  }

  String formatDateTime(String? pattern) {
    final DateFormat formatter = DateFormat(pattern);
    final String formatted = formatter.format(this);
    return formatted;
  }
}
