import 'package:cmcp/theme_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPicler extends StatefulWidget {
  final void Function(String latLong, String address) locationPickFn;
  LocationPicler(this.locationPickFn);
  @override
  _LocationPiclerState createState() => _LocationPiclerState();
}

class _LocationPiclerState extends State<LocationPicler> {
  String location = 'Null, Press Button';
  String Address = 'None';
  String latLong = '';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      Address = '${place.street}, ${place.subLocality}, ${place.locality}';
    });
  }

  void _getLocation() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    await GetAddressFromLatLong(position);
    setState(() {
      latLong = '${position.latitude},${position.longitude}';
    });
    widget.locationPickFn(latLong, Address);
  }

  @override
  void initState() {
    _getLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Text(
            Address,
            style: secondaryTextStyle(color: gray_text_color),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.gps_fixed),
              color: t3_colorPrimary,
              onPressed: _getLocation,
            ),
          ),
        ),
      ],
    ).paddingOnly(left: 15, top: 5);
  }
}
