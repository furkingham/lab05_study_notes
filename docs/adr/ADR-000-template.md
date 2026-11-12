# ADR-001: AI help for Parts 1-4 (models, repositories, NotesScreen) and the Gradle build

**Date:** 2026-11-12  **Author:** Furkan KIRBIYIK **Milestone:** Lab 05
**Tool and model used:** Claude (chat) and, earlier, Gemini (chat)

## Context
I had to complete the TODOs in note.dart, auth_repository.dart, notes_repository.dart and
notes_screen.dart so that the 15 provided tests pass. Before that, the app would not build
because of Java 25 / Gradle 8.14 / AGP / Kotlin / NDK version conflicts.

## Prompt
```
Here is my lab PDF and my Gradle error output. Help me fix the Java/Gradle problem.
Later: here is my flutter test output, give me the complete code for the 4 files.
```
(No keys, passwords or firebase_options.dart content were sent. Only error output and my own code.)

## Result
- Gradle: Installed JDK 17, removed the `org.gradle.java.home` lines from android/gradle.properties,
  raised AGP to 8.11.1 and Kotlin to 2.2.20 in settings.gradle.kts. See commit "Fix Gradle, AGP and Kotlin versions".
- Code: Note model, AuthRepository (signIn/signUp/signOut/messageFor), NotesRepository
  (watchNotes/addNote/deleteNote) and NotesScreen. See commit "Parts 1-4: Note model, repositories and NotesScreen".

## Rejected suggestion(s) — at least one
- My earlier Gemini attempt had overwritten test/lab05_test.dart and test/own_test.dart with the same
  26-line file. I rejected that and restored the originals with `git restore`, because the TAs grade
  with the original test file.
- The first version of the code used named constructor parameters and a Map result from the dialog.
  This failed the provided tests (they use positional arguments and the dialog returns a record
  `(String, String)`). I changed the signatures and the dialog type to match the tests instead of
  changing the tests.
- The first messageFor texts did not match the tests, so I changed the texts, not the test.

## Verification
Ran `flutter test`: first compilation errors, then 14/16 passing, then "All tests passed" (+16).
I also wrote my own tests in test/own_test.dart and checked the security rules in the Firestore
Rules Playground (reading another user's note is denied).

## What I learned
AI code must be checked against the real tests and the real requirements; the tests were the
authority, not the AI's first guess. Gradle errors come one at a time, so I had to read each
error message and fix the next missing version.