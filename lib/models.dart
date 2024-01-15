import 'package:flutter/material.dart' show immutable;

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({required this.token});

  const LoginHandle.fooBar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) => token == other.token;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => 'LoginHandle (token =$token)';
}

enum LoginError { invalidHandle }

@immutable
class Note {
  final String title;

  const Note({required this.title});

  @override
  String toString() => 'Note ($title)';
}


final mockNotes=Iterable.generate(3,(i)=>Note(title: 'Note ${i+1}'));
