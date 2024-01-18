
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctest_project/bloc/app_event.dart';
import 'package:bloctest_project/bloc/app_state.dart';
import 'dart:math' as math;



typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

typedef AppBlocUrlLoader= Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

Future<Uint8List> _urlLoader(String url)=>NetworkAssetBundle(Uri.parse(url.toString())).load(url.toString()).then((byteData) =>  byteData.buffer.asUint8List());

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicket,
    AppBlocUrlLoader? urlLoader,
  }) : super(
      const AppState.empty()
  ) {
    on<LoadNextUrlEvent>((event, emit) async {
      //Start loading
      emit(const AppState(isLoading: true, data: null, error: null));

      final  url = (urlPicket ?? _pickRandomUrl)(urls);
      try {
        if (waitBeforeLoading != null) {
          Future.delayed(waitBeforeLoading);
        }


        final  data =  await (urlLoader??_urlLoader)(url);
        emit(AppState(isLoading: false, data: data , error: null));
      } catch (e) {
        emit(AppState(isLoading: false, data: null, error: e));
      }
    });
  }
}
