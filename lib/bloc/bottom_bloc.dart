import 'package:bloctest_project/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({required Iterable<String> urls, Duration? waitBeforeLoading})
      : super(urls: urls, waitBeforeLoading: waitBeforeLoading);
}
