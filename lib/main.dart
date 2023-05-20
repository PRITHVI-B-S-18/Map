import 'package:flutter/material.dart';
import 'package:map/Api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Places',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nearby Places'),
        ),
        body: NearbyPlacesWidget(),
      ),
    );
  }
}

