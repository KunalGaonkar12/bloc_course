import 'package:bloc/bloc.dart';
import 'package:bloctest_project/bloc/app_event.dart';
import 'package:bloctest_project/bloc/app_state.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

typedef AppBlocRandomUrlPicket = String Function(Iterable<String> allUrls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _picRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc({
    AppBlocRandomUrlPicket? urlPicket,
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emmit) async {
      //Start loading
      emit(const AppState(isLoading: true, data: null, error: null));

      final url = (urlPicket ?? _picRandomUrl(urls));
      try {
        if (waitBeforeLoading != null) {
          Future.delayed(waitBeforeLoading);
        }

        final bundle = NetworkAssetBundle(Uri.parse(url.toString()));
        final data = (await bundle.load(url.toString())).buffer.asUint8List();
        emit(AppState(isLoading: false, data: data, error: null));
      } catch (e) {
        emit(AppState(isLoading: false, data: null, error: e));
      }
    });
  }
}
