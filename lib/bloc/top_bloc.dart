import 'package:bloctest_project/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  TopBloc({required Iterable<String> urls, Duration? waitBeforeLoading})
      : super(urls: urls, waitBeforeLoading: waitBeforeLoading);
}
