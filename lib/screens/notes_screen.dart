import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_repository.dart';
import '../data/notes_repository.dart';
import '../models/note.dart';
import 'add_note_dialog.dart';

class NotesScreen extends StatelessWidget {
  final String uid;

  const NotesScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final notesRepo = context.read<NotesRepository>();
    final authRepo = context.read<AuthRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => authRepo.signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add note',
        child: const Icon(Icons.add),
        onPressed: () async {
        final result = await showDialog<(String, String)>(                  context: context,
            builder: (_) => const AddNoteDialog(),
          );
          if (result == null) return;
          try {
           await notesRepo.addNote(uid, result.$1, result.$2); } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
      body: StreamBuilder<List<Note>>(
        stream: notesRepo.watchNotes(uid),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(child: Text('Could not load notes.'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snap.data!;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final n = notes[i];
              return Dismissible(
                key: ValueKey(n.id),
                onDismissed: (_) => notesRepo.deleteNote(uid, n.id),
                child: ListTile(title: Text(n.title), subtitle: Text(n.body)),
              );
            },
          );
        },
      ),
    );
  }
}