import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../models/session.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/session_provider.dart';

class SessionDetailPage extends StatelessWidget {
  final Session session;
  const SessionDetailPage({super.key, required this.session});

  void _joinSession(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      final participant = {
        'userId': user.uid,
        'firstName': user.firstName ?? '',
        'lastName': user.lastName ?? '',
      };
      context.read<SessionProvider>().addParticipant(
        session,
        participant,
        userId: user.uid,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вы добавлены в участники!')),
      );
      // Обновить экран, чтобы вкладка "Участники" сразу отобразила нового участника
      (context as Element).markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext c) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(session.name),
        bottom: const TabBar(
          tabs: [Tab(text: 'About'), Tab(text: 'Участники')],
        ),
      ),
      body: TabBarView(
        children: [
          _AboutTab(session: session, onJoin: (ctx) => _joinSession(ctx)),
          _ParticipantsTab(session: session),
        ],
      ),
    ),
  );
}

class _AboutTab extends StatelessWidget {
  final Session session;
  final void Function(BuildContext)? onJoin;
  const _AboutTab({required this.session, this.onJoin});

  Future<String> _getAddress() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        session.lat,
        session.lng,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return [
          p.street,
          p.locality,
          p.administrativeArea,
          p.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (_) {}
    return 'lat: ${session.lat}, lng: ${session.lng}';
  }

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (session.imagePath != null && session.imagePath!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(session.imagePath!),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 160,
              color: colorScheme.surface,
              child: const Center(
                child: Icon(Icons.event, size: 80, color: Colors.white70),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Chip(label: Text(session.language)),
            if (session.vipOnly) Chip(label: Text('VIP')),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          session.description,
          style: Theme.of(c).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(session.lat, session.lng),
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('session'),
                position: LatLng(session.lat, session.lng),
                infoWindow: InfoWindow(title: session.name),
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            liteModeEnabled: true,
          ),
        ),
        const SizedBox(height: 16),
        // Дата, время, город, цена
        ...[
          [
            'Дата',
            '${session.dateTime.day.toString().padLeft(2, '0')}.${session.dateTime.month.toString().padLeft(2, '0')}.${session.dateTime.year}, ${session.dateTime.hour.toString().padLeft(2, '0')}:${session.dateTime.minute.toString().padLeft(2, '0')}',
          ],
          ['Город', session.city],
          ['Цена', '${session.price.toStringAsFixed(0)}₸'],
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(
                  '${e[0]}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
                Text(
                  e[1],
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Локация (адрес)
        FutureBuilder<String>(
          future: _getAddress(),
          builder:
              (context, snap) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      'Локация: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        snap.data ?? '...',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onJoin == null ? null : () => onJoin!(c),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Выбрать сессию'),
        ),
      ],
    );
  }
}

class _ParticipantsTab extends StatelessWidget {
  final Session session;
  const _ParticipantsTab({required this.session});
  @override
  Widget build(BuildContext context) {
    final participants = session.participants;
    if (participants.isEmpty) {
      return const Center(child: Text('Нет участников'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: participants.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        final p = participants[i];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            (p['firstName']?.isNotEmpty == true ||
                    p['lastName']?.isNotEmpty == true)
                ? '${p['firstName'] ?? ''} ${p['lastName'] ?? ''}'.trim()
                : 'Без имени',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.95),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
