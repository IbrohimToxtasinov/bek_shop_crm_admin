part of 'change_products_cost_cubit.dart';

@immutable
sealed class ChangeProductsCostState {}

final class ChangeProductsCostInitial extends ChangeProductsCostState {}

/// Change Products Cost
final class ChangeProductsCostLoading extends ChangeProductsCostState {}

final class ChangeProductsCostSuccess extends ChangeProductsCostState {}

final class ChangeProductsCostFailure extends ChangeProductsCostState {
  final String errorMessage;

  ChangeProductsCostFailure({required this.errorMessage});
}

/// Get Products Cost
final class GetProductsCostLoading extends ChangeProductsCostState {}

final class GetProductsCostSuccess extends ChangeProductsCostState {
  final bool isExpensive;

  GetProductsCostSuccess({required this.isExpensive});
}

final class GetProductsCostFailure extends ChangeProductsCostState {
  final String errorMessage;

  GetProductsCostFailure({required this.errorMessage});
}
