import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;

  const MapScreen({required this.initialLocation, super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onTap(LatLng location) {
    print("location $location");
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, _selectedLocation);
              },
            ),
        ],
        
      ),
      body: flutterMap(widget, _onTap, _selectedLocation),
    );
  }
}

Widget flutterMap(widget, onTap, selectedLocation) {
  return FlutterMap(
    options: MapOptions(
      initialCenter: selectedLocation,
      initialZoom: 9.2,
      onTap: (_, latLng) => onTap(latLng),
    ),
    children: [
      TileLayer(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/mujahed710/clxc4m1k200t801qs21xu7eae/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibXVqYWhlZDcxMCIsImEiOiJjbHhjMTNiOHgwNHBwMmxzNTFkdmZ5b2QwIn0.lkvWQoml1T6mB-5yqWiBgg',
        userAgentPackageName: 'com.example.app',
      ),
      RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      ),
      if (selectedLocation != null)
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: selectedLocation!,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ],
        ),
    ],
  );
}
