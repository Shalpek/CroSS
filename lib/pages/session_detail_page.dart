import 'package:flutter/material.dart';
import 'dart:io';
import '../models/session.dart';

class SessionDetailPage extends StatelessWidget {
  final Session session;
  const SessionDetailPage({super.key, required this.session});

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
          _AboutTab(session: session),
          Center(
            child: Text('Здесь будут участники'),
          ), // TODO: заполнить при необходимости
        ],
      ),
    ),
  );
}

class _AboutTab extends StatelessWidget {
  final Session session;
  const _AboutTab({required this.session});
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
              child: const Center(child: Icon(Icons.event, size: 80)),
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
        ...[
          [
            'Дата',
            '${session.dateTime.day.toString().padLeft(2, '0')}.${session.dateTime.month.toString().padLeft(2, '0')}.${session.dateTime.year}, ${session.dateTime.hour.toString().padLeft(2, '0')}:${session.dateTime.minute.toString().padLeft(2, '0')}',
          ],
          ['Локация', 'lat: ${session.lat}, lng: ${session.lng}'],
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(
                  '${e[0]}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(e[1]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.pop(c),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Выбрать сессию'),
        ),
      ],
    );
  }
}
