import 'package:flutter/foundation.dart' show immutable;

import '../models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({required String email, required String password});

}


@immutable
class LoginApi implements LoginApiProtocol {

  // const LoginApi._sharedInstance();
  //
  // static const LoginApi _shared = LoginApi._sharedInstance();
  //
  // factory LoginApi.instance()=> _shared;
  const  LoginApi();

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) => Future.delayed(
    const Duration(seconds: 2), () => email == 'foo@bar.com' &&
      password == 'foobar',).then((isLoggedIn) => isLoggedIn ?const LoginHandle.fooBar():null);

}