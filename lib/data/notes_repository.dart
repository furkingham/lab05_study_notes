import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesRepository {
  final FirebaseFirestore _db;

  NotesRepository(this._db);

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('notes');

  Stream<List<Note>> watchNotes(String uid) {
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => Note.fromFirestore(d.id, d.data())).toList());
  }

  Future<void> addNote(String uid, String title, String body) async {
    final t = title.trim();
    if (t.isEmpty || t.length > 100) {
      throw ArgumentError('Title must be 1-100 characters.');
    }
    await _col(uid)
        .add(Note(id: '', title: t, body: body.trim()).toFirestore());
  }

  Future<void> deleteNote(String uid, String noteId) =>
      _col(uid).doc(noteId).delete();
}