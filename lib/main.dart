import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;

import 'dart:developer' as devtools show log;

extension Log on Object{
  void log()=> devtools.log(toString());
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider<PersonsBloc>(
          create: (_) => PersonsBloc(),
          child: HomePage(),
        ));
  }
}


//Event class
@immutable
abstract class LoadAction {
  const LoadAction();
}

//Event sub class
@immutable
class LoadPersonAction extends LoadAction {
  final PersonUrl url;

  const LoadPersonAction({required this.url}) : super();
}


//Ur
enum PersonUrl {
  person1,
  person2,
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Person.formJson(Map<String, dynamic> json)
      : name = json["name"] as String,
        age = json["age"] as int;


  @override
   String toString()=> "Person name=$name, age=$age";
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return "http://10.0.2.2:5500/api/person1.json";
      case PersonUrl.person2:
        return "http://10.0.2.2:5500/api/person2.json";
    }
  }
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.formJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult(
      {required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      "FetchResult (isRetrievedFromCache =$isRetrievedFromCache, persons=$persons)";
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;
        final result =
            FetchResult(persons: cachedPersons, isRetrievedFromCache: true);
        emit(result);
      }else{
        final persons = await getPersons(url.urlString);
        _cache[url] =  persons ;
        final result = FetchResult(
            persons:  persons , isRetrievedFromCache: false);
        emit(result);
      }

    });
  }
}

extension SubScript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonAction(url: PersonUrl.person1));
                },
                child: Text("Load json 1"),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonAction(url: PersonUrl.person2));
                },
                child: Text("Load json 2"),
              ),

            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) =>
              previousResult?.persons != currentResult!.persons,
              builder: (context, fetchResult) {
                fetchResult?.log();
                var persons = fetchResult?.persons;
                if (persons == null) {
                  return SizedBox();
                }
                return
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final person = persons[index];
                      return ListTile(
                        title: Text(person!.name),
                      );
                    },
                    itemCount: persons.length,
                  );


              })
        ],
      ),
    );
  }
}
