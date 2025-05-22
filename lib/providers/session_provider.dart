// lib/providers/session_provider.dart
import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionProvider extends ChangeNotifier {
  final List<Session> _sessions = [Session.example()];

  List<Session> get sessions => List.unmodifiable(_sessions);

  void addSession(Session session) {
    _sessions.add(session);
    notifyListeners();
  }
}
