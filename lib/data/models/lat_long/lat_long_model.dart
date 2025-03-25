class LatLongModel {
  final double latitude;
  final double longitude;

  LatLongModel({required this.latitude, required this.longitude});

  factory LatLongModel.fromJson(Map<String, dynamic> json) {
    return LatLongModel(
      latitude: json["latitude"] as double? ?? 0.0,
      longitude: json["longitude"] as double? ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
