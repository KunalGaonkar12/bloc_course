import 'package:bloctest_project/apis/login_api.dart';
import 'package:bloctest_project/apis/notes_api.dart';
import 'package:bloctest_project/bloc/actions.dart';
import 'package:bloctest_project/bloc/app_bloc.dat.dart';
import 'package:bloctest_project/bloc/app_state.dart';
import 'package:bloctest_project/dialogs/generic_dialog.dart';
import 'package:bloctest_project/dialogs/loading_screen.dart';
import 'package:bloctest_project/global.dart';
import 'package:bloctest_project/models.dart';
import 'package:bloctest_project/strings.dart';
import 'package:bloctest_project/views/iterable_list_view.dart';
import 'package:bloctest_project/views/login_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_bloc/flutter_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc(loginApi: LoginApi(), noteApi: NoteApi(),accecptedLoginHandle:const  LoginHandle.fooBar()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),centerTitle: true,
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(text: pleaseWait,context: context);
            } else {
              LoadingScreen.instance().hide();
            }

            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionBuilder: () => {ok: true});
            }

            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNote == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final note = appState.fetchedNote;
            if (note == null) {
              return LoginView(onLoginTapped: (email, password) {
                context.read<AppBloc>().add(LoginAction(email: email, password: password));
              });
            }else{
              return IterableListView<Note>(iterable: note);
            }
          },
        ),
      ),
    );
  }
}
