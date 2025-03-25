part of 'location_bloc.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionGranted extends LocationState {
  final String addressName;
  final LatLongModel latLongModel;

  LocationPermissionGranted({required this.addressName, required this.latLongModel});
}

class LocationPermissionDenied extends LocationState {}

class LocationPermissionDeniedForever extends LocationState {}

class LocationServiceDisabled extends LocationState {}

class GetAddressNameFailure extends LocationState {
  final LatLongModel latLongModel;
  final String errorMessage;

  GetAddressNameFailure({required this.errorMessage, required this.latLongModel});
}
