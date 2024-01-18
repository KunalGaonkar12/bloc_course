import 'dart:typed_data' show Uint8List;

import 'package:flutter/foundation.dart' show immutable;

extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> others) {
    if (identical(this, others)) {
      return true;
    }
    if (length != others.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      if (this[i] != others[i]) {
        return false;
      }
    }
    return true;
  }
}

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;

  const AppState(
      {required this.isLoading, required this.data, required this.error});

  const AppState.empty()
      : isLoading = false,
        data = null,
        error = null;

  @override
  bool operator ==(covariant AppState other) => (isLoading == other.isLoading &&
      (data ??[]).isEqualTo(other.data ??[])&&
      error == other.error);

  @override
  String toString() =>
      {'isLoading': isLoading, 'data': data != null, 'error': error}.toString();

  @override
  int get hashCode=> Object.hash(isLoading, data,error);
}
