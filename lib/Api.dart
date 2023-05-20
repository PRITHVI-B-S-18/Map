import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class NearbyPlacesWidget extends StatefulWidget {
  @override
  _NearbyPlacesWidgetState createState() => _NearbyPlacesWidgetState();
}

class _NearbyPlacesWidgetState extends State<NearbyPlacesWidget> {
  List<Place> nearbyPlaces = [];

  @override
  void initState() {
    super.initState();
    fetchNearbyPlaces();
  }

  Future<void> fetchNearbyPlaces() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latitude = position.latitude;
    final longitude = position.longitude;
    final radius = 10000; // Specify the radius in meters

    final url =
        'https://overpass-api.de/api/interpreter?data=[out:json];node(around:$radius,$latitude,$longitude);out;';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final elements = data['elements'];

      List<dynamic> elementsList = elements != null ? List.from(elements) : [];
      List<Place> places = [];

      for (var element in elementsList) {
        if (element['tags'] != null) {


          print(element); // Print the element details
          if (element['tags']['name'] != null) {
            String name = element['tags']['name'];
            print('Name: $name'); // Print the 'name' field

            String block = element['tags']['addr:block'] ?? 'Unknown';
            String district = element['tags']['addr:district'] ?? 'Unknown';
            String fullAddress = element['tags']['addr:full'] ?? 'Unknown';
            String postcode = element['tags']['addr:postcode'] ?? 'Unknown';
            String state = element['tags']['addr:state'] ?? 'Unknown';
            String subdistrict = element['tags']['addr:subdistrict'] ?? 'Unknown';
            String amenity = element['tags']['amenity'] ?? 'Unknown';
            String source = element['tags']['source'] ?? 'Unknown';
            String phone = element['tags']['phone'] ?? 'Unknown';

            places.add(
              Place(
                name: name,
                latitude: element['lat'],
                longitude: element['lon'],
                block: block,
                district: district,
                fullAddress: fullAddress,
                postcode: postcode,
                state: state,
                subdistrict: subdistrict,
                amenity: amenity,
                source: source,
                phone: phone,
              ),
            );
          }
        }
      }

      setState(() {
        nearbyPlaces = places;
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${place.latitude}, Longitude: ${place.longitude}'),
              Text('Block: ${place.block}'),
              Text('District: ${place.district}'),
              Text('Full Address: ${place.fullAddress}'),
              Text('Postcode: ${place.postcode}'),
              Text('State: ${place.state}'),
              Text('Subdistrict: ${place.subdistrict}'),
              Text('Amenity: ${place.amenity}'),
              Text('Source: ${place.source}'),
              Text('Phone: ${place.phone}'),
            ],
          ),
        );
      },
    );
  }
}

class Place {
  final String name;
  final double latitude;
  final double longitude;
  final String block;
  final String district;
  final String fullAddress;
  final String postcode;
  final String state;
  final String subdistrict;
  final String amenity;
  final String source;
  final String phone;

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.block,
    required this.district,
    required this.fullAddress,
    required this.postcode,
    required this.state,
    required this.subdistrict,
    required this.amenity,
    required this.source,
    required this.phone,
  });
}
