import 'package:bloc_test/bloc_test.dart';
import 'package:bloctest_project/apis/login_api.dart';
import 'package:bloctest_project/apis/notes_api.dart';
import 'package:bloctest_project/bloc/actions.dart';
import 'package:bloctest_project/bloc/app_bloc.dat.dart';
import 'package:bloctest_project/bloc/app_state.dart';
import 'package:bloctest_project/models.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mocNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

const LoginHandle acceptedLoginHandle=LoginHandle(token: 'ABC');

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi(
      {required this.acceptedLoginHandle,
      required this.notesToReturnForAcceptedLoginHandle});

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi(
      {required this.acceptedEmail,
      required this.handleToReturn,
      required this.acceptedPassword});

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      null;
    }
  }
}

void main() {
  group('Test  appState', () {
    blocTest<AppBloc, AppState>(
        'Initial state of the bloc should be AppState.empty(()',
        build: () => AppBloc(
            loginApi: const DummyLoginApi.empty(),
            noteApi: const DummyNotesApi.empty(),accecptedLoginHandle:acceptedLoginHandle),
        verify: (appState) => expect(appState.state, const AppState.empty()));

    blocTest<AppBloc, AppState>('can we login with correct credentials',
        build: () => AppBloc(
            loginApi: const DummyLoginApi(
                acceptedEmail: 'foo@bar.com',
                acceptedPassword: 'foobar',
                handleToReturn: LoginHandle(token: 'ABC')),
            noteApi: const DummyNotesApi.empty(),accecptedLoginHandle:acceptedLoginHandle),
        act: (appBloc) =>
            appBloc.add(LoginAction(email: 'foo@bar.com', password: 'foobar')),
        expect: () => [
              const AppState(
                  isLoading: true,
                  fetchedNote: null,
                  loginHandle: null,
                  loginError: null),
              const AppState(
                  isLoading: false,
                  loginError: null,
                  loginHandle: acceptedLoginHandle,
                  fetchedNote: null)
            ]);

    blocTest<AppBloc, AppState>('we should not be able to login with invalid credentials',
        build: () => AppBloc(
            loginApi: const DummyLoginApi(
                acceptedEmail: 'foo@bar.com',
                acceptedPassword: 'foobar',
                handleToReturn: acceptedLoginHandle),
            noteApi: const DummyNotesApi.empty(),accecptedLoginHandle: acceptedLoginHandle),
        act: (appBloc) =>
            appBloc.add(LoginAction(email: 'fo@bar.com', password: 'foobar')),
        expect: () => [
          const AppState(
              isLoading: true,
              fetchedNote: null,
              loginHandle: null,
              loginError: null),
          const AppState(
              isLoading: false,
              loginError: LoginError.invalidHandle,
              loginHandle: null,
              fetchedNote: null)
        ]);



    blocTest<AppBloc, AppState>('load some notes with valid handles',
        build: () => AppBloc(
            loginApi: const DummyLoginApi(
                acceptedEmail: 'foo@bar.com',
                acceptedPassword: 'foobar',
                handleToReturn: acceptedLoginHandle),
            noteApi: const DummyNotesApi(
              acceptedLoginHandle: acceptedLoginHandle,
              notesToReturnForAcceptedLoginHandle: mocNotes
            ),accecptedLoginHandle: acceptedLoginHandle),
        act: (appBloc) {
          appBloc.add(const LoginAction(email: 'foo@bar.com', password: 'foobar'));
          appBloc.add(const LoadNotesAction());

        },
        expect: () => [
          const AppState(
              isLoading: true,
              fetchedNote: null,
              loginHandle: null,
              loginError: null),
          const AppState(
              isLoading: false,
              loginError: null,
              loginHandle: acceptedLoginHandle,
              fetchedNote: null),
          const AppState(
              isLoading: true,
              loginError: null,
              loginHandle: acceptedLoginHandle,
              fetchedNote: null),
          const AppState(
              isLoading: false,
              loginError: null,
              loginHandle: acceptedLoginHandle,
              fetchedNote: mocNotes),
        ]);
  });
}
