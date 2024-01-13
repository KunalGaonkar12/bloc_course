import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;
import 'dart:developer' as devtools show log;
import 'bloc/bloc_actions.dart';
import 'bloc/person.dart';
import 'bloc/persons_bloc.dart';

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


Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.formJson(e)));

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
                      .add(const LoadPersonAction(url:person1Url,loader: getPersons ));
                },
                child: Text("Load json 1"),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonAction(url: person2Url,loader: getPersons));
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
                return ListView.builder(
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
