import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab05_study_notes/data/auth_repository.dart';
import 'package:lab05_study_notes/data/notes_repository.dart';

void main() {
  setUpAll(FakeFirebaseFirestore.new);

  test('messageFor maps network-request-failed', () {
    expect(AuthRepository.messageFor('network-request-failed'),
        contains('internet'));
  });

  test('a 100-character title is accepted', () async {
    final db = FakeFirebaseFirestore();
    final repo = NotesRepository(db);
    await repo.addNote('u1', 'a' * 100, 'x');
    final notes = await repo.watchNotes('u1').first;
    expect(notes.length, 1);
    expect(notes.first.title.length, 100);
  });

  test('addNote trims the body', () async {
    final db = FakeFirebaseFirestore();
    final repo = NotesRepository(db);
    await repo.addNote('u1', 'Title', '  hello  ');
    final notes = await repo.watchNotes('u1').first;
    expect(notes.first.body, 'hello');
  });
}