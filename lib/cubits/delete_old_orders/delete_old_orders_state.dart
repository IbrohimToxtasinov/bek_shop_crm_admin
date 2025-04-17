part of 'delete_old_orders_cubit.dart';

abstract class DeleteOldOrdersState {}

class DeleteOldOrdersInitial extends DeleteOldOrdersState {}

/// Delete Old Orders
class DeleteOldOrdersLoadInProgress extends DeleteOldOrdersState {}

class DeleteOldOrdersLoadInSuccess implements DeleteOldOrdersState {}

class DeleteOldOrdersLoadInFailure extends DeleteOldOrdersState {
  String errorText;

  DeleteOldOrdersLoadInFailure({required this.errorText});
}
