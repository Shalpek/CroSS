// lib/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../models/session.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  static const LatLng _center = LatLng(51.1694, 71.4491); // Астана

  @override
  Widget build(BuildContext c) {
    final sessions = context.watch<SessionProvider>().sessions;
    final Set<Marker> markers =
        sessions
            .map(
              (session) => Marker(
                markerId: MarkerId(session.id),
                position: LatLng(session.lat, session.lng),
                infoWindow: InfoWindow(
                  title: session.name,
                  snippet: session.description,
                ),
              ),
            )
            .toSet();

    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: const Text('Карта')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: _center, zoom: 12),
        markers: markers,
        onMapCreated: (controller) => _controller = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
