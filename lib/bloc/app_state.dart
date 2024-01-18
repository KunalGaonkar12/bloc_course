import 'package:bloctest_project/models.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:collection/collection.dart';

extension UnorderedEquality on Object {
  bool isEqualTo(other) =>
      const DeepCollectionEquality.unordered().equals(this, other);
}

@immutable
class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNote;

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNote = null;

  const AppState(
      {required this.isLoading,
      this.loginError,
      this.loginHandle,
      this.fetchedNote});

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandler': loginHandle,
        'fetchedNotes': fetchedNote,
      }.toString();

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesAreEqual = isLoading == other.isLoading &&
        loginError == other.loginError &&
        loginHandle == other.loginHandle;
    if (fetchedNote == null && other.fetchedNote == null) {
      return otherPropertiesAreEqual;
    } else {
      return otherPropertiesAreEqual &&
          (fetchedNote?.isEqualTo(other.fetchedNote) ?? false);
    }
  }

  @override
  int get hasCode=>Object.hash(isLoading,loginError,loginHandle,fetchedNote);
}
