part of 'location_bloc.dart';

abstract class LocationEvent {}

class RequestLocationPermission extends LocationEvent {
  final int delay;

  RequestLocationPermission({this.delay = 0});
}

class FetchAddressName extends LocationEvent {
  final LatLongModel latLongModel;

  FetchAddressName({required this.latLongModel});
}
