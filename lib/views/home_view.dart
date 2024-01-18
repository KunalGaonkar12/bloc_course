import 'package:bloctest_project/bloc/top_bloc.dart';
import 'package:bloctest_project/models/constants.dart';
import 'package:bloctest_project/views/app_bloc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bottom_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
                create: (_) => TopBloc(
                    urls: images,
                    waitBeforeLoading: const Duration(seconds: 3))),
            BlocProvider<BottomBloc>(
                create: (_) => BottomBloc(
                    urls: images,
                    waitBeforeLoading: const Duration(seconds: 3))),
          ],
          child: const Column(
            children: [AppBlocView<TopBloc>(), AppBlocView<BottomBloc>()],
          ),
        ),
      ),
    );
  }
}
