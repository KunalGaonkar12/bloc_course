import 'package:bloctest_project/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNote;

  const AppState.empty()
      :isLoading=false,
        loginError=null,
        loginHandle=null,
        fetchedNote=null;

  const AppState({
    required this.isLoading,
    this.loginError,
    this.loginHandle,
    this.fetchedNote
  });

  @override
  String toString() =>
      {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandler': loginHandle,
        'fetchedNotes': fetchedNote,
      }.toString();
}

