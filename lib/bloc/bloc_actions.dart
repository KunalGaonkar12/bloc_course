import 'package:bloctest_project/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;



const person1Url="http://10.0.2.2:5500/api/person1.json";
const person2Url="http://10.0.2.2:5500/api/person2.json";

typedef PersonLoader= Future<Iterable<Person>>  Function(String url);


//Event class
@immutable
abstract class LoadAction {
  const LoadAction();
}

//Event sub class
@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonLoader loader;

  const LoadPersonAction({required this.url,required this.loader}) : super();
}