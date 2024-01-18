import 'dart:typed_data';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloctest_project/bloc/app_bloc.dart';
import 'package:bloctest_project/bloc/app_event.dart';
import 'package:bloctest_project/bloc/app_state.dart';
import 'package:bloctest_project/models/constants.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final test1Data = 'Foo'.toUint8List();
final test2Data = 'Bar'.toUint8List();

enum Error { Dummy }

void main() {
  group('To test the bloc', () {
    blocTest<AppBloc, AppState>(
        'Initial state of the bloc should be AppState.empty()',
        build: () => AppBloc(urls: images),
        verify: (appBloc) => expect(appBloc.state, const AppState.empty()));

    //Load valid data and compare state
    blocTest<AppBloc, AppState>('Load valid data and compare state',
        build: () => AppBloc(
              urls: images,
              urlPicket: (_) => '',
              urlLoader: (_) => Future.value(test1Data),
            ),
        act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
        expect: () => [
              const AppState(isLoading: true, data: null, error: null),
              AppState(isLoading: false, data: test1Data, error: null)
            ]);

    //Test throwing error from url loader and catch
    blocTest<AppBloc, AppState>('Test throwing error from url loader and catch',
        build: () => AppBloc(
              urls: images,
              urlPicket: (_) => '',
              urlLoader: (_) => Future.error(Error.Dummy),
            ),
        act: (appBloc) => appBloc.add(const LoadNextUrlEvent()),
        expect: () => [
              const AppState(isLoading: true, data: null, error: null),
              const AppState(isLoading: false, data: null, error: Error.Dummy)
            ]);

    //Load valid data and compare state
    blocTest<AppBloc, AppState>('Test the ability to load more than one URL',
        build: () => AppBloc(
          urls: images,
          urlPicket: (_) => '',
          urlLoader: (_) => Future.value(test2Data),
        ),
        act: (appBloc) {
          appBloc.add(const LoadNextUrlEvent());
          appBloc.add(const LoadNextUrlEvent());
        } ,
        expect: () => [
          const AppState(isLoading: true, data: null, error: null),
          AppState(isLoading: false, data: test2Data, error: null),
          const AppState(isLoading: true, data: null, error: null),
          AppState(isLoading: false, data: test2Data, error: null)
        ]);
  });
}
