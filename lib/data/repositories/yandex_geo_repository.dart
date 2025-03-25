import 'package:bek_shop/data/models/lat_long/lat_long_model.dart';
import 'package:bek_shop/data/models/responses/app_response.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class YandexGeoRepository {
  final Dio dio = Dio();
  final List<String> apiKeys = ["c07bed91-20af-4746-837b-c9a410488156"];

  Future<AppResponse> getPlaceNameByLocation(LatLongModel latLng) async {
    final AppResponse appResponse = AppResponse();
    String? province;
    String? district;
    String? city;
    String? street;

    for (String apiKey in apiKeys) {
      try {
        final response = await dio.get(
          'https://geocode-maps.yandex.ru/1.x/',
          queryParameters: {
            "apikey": apiKey,
            "geocode": "${latLng.longitude},${latLng.latitude}",
            'lang': "uz",
            'format': 'json',
            'rspn': '1',
            'results': '1',
          },
        );

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final data = response.data as Map<String, dynamic>;
          final featureMember = data["response"]["GeoObjectCollection"]["featureMember"] as List?;

          if (featureMember != null && featureMember.isNotEmpty) {
            final geoObject = featureMember[0]["GeoObject"];
            final addressComponents =
                geoObject["metaDataProperty"]["GeocoderMetaData"]["Address"]["Components"] as List?;

            if (addressComponents != null && addressComponents.isNotEmpty) {
              for (var component in addressComponents) {
                if (component["kind"] == "province") {
                  province = component["name"];
                } else if (component["kind"] == "district") {
                  district = component["name"];
                } else if (component["kind"] == "locality") {
                  city = component["name"];
                } else if (component["kind"] == "street") {
                  street = component["name"];
                }
              }
            }
          }
        } else {
          appResponse.errorMessage = "Failed to fetch data";
          appResponse.statusCode = response.statusCode;
        }

        if (province != null || district != null || city != null || street != null) {
          appResponse.data =
              "${province ?? ""}${district != null ? ", $district" : ""}${city != null ? ", $city" : ""}${street != null ? ", $street" : ""}";
          break;
        }
      } catch (error) {
        if (error is DioException) {
          if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
            debugPrint("API key error, trying another key: $apiKey");
            continue;
          } else {
            appResponse.errorMessage = error.message.toString();
            appResponse.statusCode = error.response?.statusCode;
            break;
          }
        } else {
          appResponse.errorMessage = error.toString();
          debugPrint("Error: ${appResponse.errorMessage}");
          break;
        }
      }
    }
    appResponse.data ??= "".tr();

    return appResponse;
  }
}
