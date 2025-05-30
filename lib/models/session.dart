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
  final String city; // город проведения
  final double price; // цена
  List<Map<String, String>> participants; // список участников

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
    required this.city,
    required this.price,
    this.participants = const [],
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
    city: 'Astana',
    price: 1000,
    participants: const [],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'dateTime': dateTime.toIso8601String(),
    'language': language,
    'vipOnly': vipOnly,
    'lat': lat,
    'lng': lng,
    'imagePath': imagePath,
    'city': city,
    'price': price,
    'participants': participants,
  };

  factory Session.fromMap(Map<String, dynamic> map) => Session(
    id: map['id'] as String,
    name: map['name'] as String,
    description: map['description'] as String,
    dateTime: DateTime.parse(map['dateTime'] as String),
    language: map['language'] as String,
    vipOnly: map['vipOnly'] as bool,
    lat: (map['lat'] as num).toDouble(),
    lng: (map['lng'] as num).toDouble(),
    imagePath: map['imagePath'] as String?,
    city: map['city'] as String,
    price: (map['price'] as num).toDouble(),
    participants:
        (map['participants'] as List?)
            ?.map((e) => Map<String, String>.from(e as Map))
            .toList() ??
        [],
  );
}
