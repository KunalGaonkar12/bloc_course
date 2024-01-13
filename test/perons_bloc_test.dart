import 'package:bloctest_project/bloc/bloc_actions.dart';
import 'package:bloctest_project/bloc/person.dart';
import 'package:bloctest_project/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockPersons1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockPersons2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPerson1(String _) => Future.value(mockPersons1);

Future<Iterable<Person>> mockGetPerson2(String _) => Future.value(mockPersons1);

void main() {
  group('Test Bloc', () {
    late PersonsBloc bloc;

    //This is used to create initial set up in this case create an instance of bloc class for every test
    // i.e for each test in group it will create fresh object or instance
    setUp(() {
      bloc = PersonsBloc();
    });

    //Test initial state of bloc
    blocTest<PersonsBloc, FetchResult?>('Test initial state',
        build: () => bloc, verify: (bloc) => expect(bloc.state,null));

    //Test the fetching of data for person1 and compare with FetchResults
    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from First iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add( const LoadPersonAction(url: '_dummy_1', loader: mockGetPerson1));
          bloc.add( const LoadPersonAction(url: '_dummy_1', loader: mockGetPerson1));
        },expect: ()=>[
          FetchResult(persons: mockPersons1, isRetrievedFromCache: false),
          FetchResult(persons: mockPersons1, isRetrievedFromCache: true),
    ]);

    //Test the fetching of data for person2 and compare with FetchResults
    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from Second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add( const LoadPersonAction(url: '_dummy_2', loader: mockGetPerson2));
          bloc.add( const LoadPersonAction(url: '_dummy_2', loader: mockGetPerson2));
        },expect: ()=>[
          FetchResult(persons: mockPersons2, isRetrievedFromCache: false),
          FetchResult(persons: mockPersons2, isRetrievedFromCache: true),
    ]);
  });
}
