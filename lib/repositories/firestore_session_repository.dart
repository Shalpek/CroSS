import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session.dart';

class FirestoreSessionRepository {
  final _sessions = FirebaseFirestore.instance.collection('sessions');

  Future<void> addSession(Session session) async {
    await _sessions.doc(session.id).set(session.toMap());
  }

  Future<void> updateSession(Session session) async {
    await _sessions.doc(session.id).update(session.toMap());
  }

  Future<void> deleteSession(String id) async {
    await _sessions.doc(id).delete();
  }

  Future<List<Session>> getSessions() async {
    final snapshot = await _sessions.get();
    return snapshot.docs.map((doc) => Session.fromMap(doc.data())).toList();
  }

  Stream<List<Session>> sessionsStream() {
    return _sessions.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Session.fromMap(doc.data())).toList(),
    );
  }
}
