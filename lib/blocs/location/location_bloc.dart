import 'package:bek_shop/data/models/lat_long/lat_long_model.dart';
import 'package:bek_shop/data/models/responses/app_response.dart';
import 'package:bek_shop/data/repositories/yandex_geo_repository.dart';
import 'package:bek_shop/utils/mixins/location_mixin.dart';
import 'package:bloc/bloc.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> with LocationMixin {
  LocationBloc(this._yandexGeoRepository) : super(LocationInitial()) {
    on<RequestLocationPermission>(_requestLocationPermission);
    on<FetchAddressName>(_fetchAddressName);
  }

  final YandexGeoRepository _yandexGeoRepository;

  Future<void> _requestLocationPermission(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    await makeLocationRequestPermission(
      delay: event.delay,
      resultPermission: (position) {
        add(
          FetchAddressName(
            latLongModel: LatLongModel(latitude: position!.latitude, longitude: position.longitude),
          ),
        );
      },
      denied: () => emit(LocationPermissionDenied()),
      deniedForever: () => emit(LocationPermissionDeniedForever()),
      serviceDisabled: () => emit(LocationServiceDisabled()),
    );
  }

  Future<void> _fetchAddressName(FetchAddressName event, Emitter<LocationState> emit) async {
    AppResponse appResponse = await _yandexGeoRepository.getPlaceNameByLocation(event.latLongModel);
    if (appResponse.errorMessage.isEmpty) {
      emit(
        LocationPermissionGranted(addressName: appResponse.data, latLongModel: event.latLongModel),
      );
    } else {
      emit(
        GetAddressNameFailure(
          errorMessage: appResponse.errorMessage,
          latLongModel: event.latLongModel,
        ),
      );
    }
  }
}
