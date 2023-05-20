import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyPlacesWidgets extends StatefulWidget {
  @override
  _NearbyPlacesWidgetStates createState() => _NearbyPlacesWidgetStates();
}

class _NearbyPlacesWidgetStates extends State<NearbyPlacesWidgets> {
  List<Place> nearbyPlaces = [];

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      fetchNearbyPlaces();
    } else {
      // Handle permission denied
    }
  }

  Future<void> fetchNearbyPlaces() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latitude = position.latitude;
    final longitude = position.longitude;

    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=hotels&lat=$latitude&lon=$longitude&radius=10000';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final places = List<Map<String, dynamic>>.from(data);

      setState(() {
        nearbyPlaces = places
            .map((place) => Place(
          name: place['display_name'],
          latitude: double.parse(place['lat']),
          longitude: double.parse(place['lon']),
        ))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nearbyPlaces.length,
      itemBuilder: (BuildContext context, int index) {
        final place = nearbyPlaces[index];
        return ListTile(
          title: Text(place.name),
          subtitle: Text(
              'Latitude: ${place.latitude}, Longitude: ${place.longitude}'),
        );
      },
    );
  }
}

class Place {
  final String name;
  final double latitude;
  final double longitude;

  Place({required this.name, required this.latitude, required this.longitude});
}
