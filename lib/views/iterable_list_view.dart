import 'package:bloctest_project/models.dart';
import 'package:flutter/material.dart';


extension ToListView<T> on Iterable<T>{
  Widget toListView()=> IterableListView(iterable: this);
}
class IterableListView<T> extends StatelessWidget {
  final Iterable<T> iterable;

  const IterableListView({required this.iterable, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: iterable.length,
        itemBuilder: (context, index) {
          var note = iterable.elementAt(index);
          return ListTile(
            title: Text(note.toString()),
          );
        });
  }
}
