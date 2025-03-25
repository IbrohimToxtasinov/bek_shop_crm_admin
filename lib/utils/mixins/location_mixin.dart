import 'package:geolocator/geolocator.dart';

mixin LocationMixin {
  Position? locationData;

  Future<void> listenLocationChange() async {
    final isGrantedPermission = await hasPermission;
    if (isGrantedPermission) {
      Geolocator.getPositionStream().listen((locationData) {
        this.locationData = locationData;
      });
    }
  }

  Future<void> makeLocationRequestPermission({
    int delay = 1,
    Function(Position? position)? resultPermission,
    Function()? deniedForever,
    Function()? denied,
    Function()? serviceDisabled,
    Function()? awaiting,
  }) {
    LocationPermission permission;
    awaiting?.call();
    return Future.delayed(Duration(seconds: delay), () async {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        deniedForever!.call();
        return;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          deniedForever!.call();
          return;
        }
        if (permission == LocationPermission.denied) {
          denied!.call();
          return;
        }
      }
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        serviceDisabled?.call();
        return;
      }

      resultPermission?.call(await Geolocator.getCurrentPosition());
    });
  }
}

Future<bool> get hasPermission async {
  final permission = await Geolocator.checkPermission();
  return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
}
