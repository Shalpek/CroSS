// lib/providers/session_provider.dart
import 'package:flutter/material.dart';
import '../models/session.dart';
import '../repositories/firestore_session_repository.dart';

class SessionProvider extends ChangeNotifier {
  final FirestoreSessionRepository _firestore = FirestoreSessionRepository();
  final List<Session> _sessions = [];
  bool _isLoaded = false;

  List<Session> get sessions => List.unmodifiable(_sessions);

  Future<void> loadSessions() async {
    if (_isLoaded) return;
    final loaded = await _firestore.getSessions();
    _sessions.clear();
    _sessions.addAll(loaded);
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addSession(Session session) async {
    _sessions.add(session);
    await _firestore.addSession(session);
    notifyListeners();
  }

  Future<void> addParticipant(
    Session session,
    Map<String, String> participant, {
    String? userId,
  }) async {
    final idx = _sessions.indexWhere((s) => s.id == session.id);
    if (idx != -1) {
      final participants = List<Map<String, String>>.from(
        _sessions[idx].participants,
      );
      final existingIdx =
          userId != null
              ? participants.indexWhere((p) => p['userId'] == userId)
              : -1;
      if (existingIdx != -1) {
        participants[existingIdx] = participant;
      } else {
        participants.add(participant);
      }
      _sessions[idx].participants = participants;
      await _firestore.updateSession(_sessions[idx]);
      notifyListeners();
    }
  }

  Future<void> updateParticipantNames(
    String userId,
    String firstName,
    String lastName,
  ) async {
    for (final session in _sessions) {
      final participants = List<Map<String, String>>.from(session.participants);
      final idx = participants.indexWhere((p) => p['userId'] == userId);
      if (idx != -1) {
        participants[idx]['firstName'] = firstName;
        participants[idx]['lastName'] = lastName;
        session.participants = participants;
        await _firestore.updateSession(session);
      }
    }
    notifyListeners();
  }
}
