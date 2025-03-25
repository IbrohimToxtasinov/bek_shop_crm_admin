part of 'order_bloc.dart';

abstract class OrderEvent {}

class FetchOrders extends OrderEvent {}

class CreateOrder extends OrderEvent {
  final String clientName;
  final String clientPhoneNumber;
  final String clientAddress;
  final LatLongModel latLong;
  final List<CartModel> products;

  CreateOrder({
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientAddress,
    required this.latLong,
    required this.products,
  });
}
