import 'package:bek_shop/data/models/lat_long/lat_long_model.dart';
import 'package:bek_shop/data/models/order/order_product_model.dart';

class OrderModel {
  final String orderId;
  final String clientName;
  final String clientPhoneNumber;
  final String clientAddress;
  final String createAt;
  final num totalPrice;
  final LatLongModel latLong;
  final List<OrderProductModel> products;

  OrderModel({
    required this.orderId,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientAddress,
    required this.createAt,
    required this.totalPrice,
    required this.latLong,
    required this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json["order_id"] as String? ?? "",
      clientName: json["client_name"] as String? ?? "",
      clientPhoneNumber: json["client_phone_number"] as String? ?? "",
      clientAddress: json["client_address"] as String? ?? "",
      createAt: json["create_at"] as String? ?? "",
      totalPrice: json["total_price"] as num? ?? 0,
      latLong: LatLongModel.fromJson(json["lat_long"] as Map<String, dynamic>? ?? {}),
      products:
          (json["products"] as List<dynamic>? ?? [])
              .map((x) => OrderProductModel.fromJson(x as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "client_name": clientName,
      "client_phone_number": clientPhoneNumber,
      "client_address": clientAddress,
      "create_at": createAt,
      "total_price": totalPrice,
      "lat_long": latLong.toJson(),
      "products": products.map((product) => product.toJson()).toList(),
    };
  }
}
