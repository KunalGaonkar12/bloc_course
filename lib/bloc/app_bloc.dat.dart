import 'package:bloctest_project/apis/notes_api.dart';
import 'package:bloctest_project/bloc/actions.dart';
import 'package:bloctest_project/bloc/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apis/login_api.dart';
import '../models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol noteApi;

  AppBloc({required this.loginApi, required this.noteApi})
      : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      emit(const AppState(isLoading: true));

      final loginHandler =
          await loginApi.login(email: event.email, password: event.password);
      emit(AppState(
          isLoading: false,
          loginError: loginHandler == null ? LoginError.invalidHandle : null,
      loginHandle: loginHandler,fetchedNote: null));
    });

    on<LoadNotesAction>((event, emit) async {
      emit( AppState(isLoading: true,loginHandle: state.loginHandle,fetchedNote: null));
      final  loginHandler= state.loginHandle;

      //invalid login handle cannot fetch notes
      if(loginHandler!=const LoginHandle.fooBar()){
        emit( AppState(isLoading: false,loginError: LoginError.invalidHandle,loginHandle: loginHandler));
return ;
      }
      //we have valid login 
      
      final note= await noteApi.getNotes(loginHandle: loginHandler!); 
      emit(AppState(isLoading: false,loginHandle: loginHandler,fetchedNote: note));
    });
  }
}
