// lib/models/session.dart
import 'package:flutter/material.dart';

class Session {
  final String id;
  final String name;
  final String description;
  final DateTime dateTime;
  final String language;
  final bool vipOnly;
  final double lat;
  final double lng;
  final String? imagePath; // путь к изображению (локальный или network)

  Session({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
    required this.language,
    required this.vipOnly,
    required this.lat,
    required this.lng,
    this.imagePath,
  });

  factory Session.example() => Session(
    id: '1',
    name: 'Бильярд',
    description:
        'Играем в бильярд, AITUSA. Призы есть, приходить с хорошим настроением.',
    dateTime: DateTime(2025, 4, 7, 14, 40),
    language: 'ru',
    vipOnly: false,
    lat: 51.1694,
    lng: 71.4491,
    imagePath: null,
  );
}
