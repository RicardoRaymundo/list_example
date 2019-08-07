import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:list_example/photo/photo.dart';
import 'package:list_example/photo/photo_list.dart';


void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: _MainApp(title: appTitle),
    );
  }
}

class _MainApp extends StatelessWidget {
  final String title;

  _MainApp({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // FutureBuilder que recebe a lista de Photo
      body: FutureBuilder<List<Photo>>(
        // A future é o processamento do json do servidor
        // Recebe List<Photo>
        future: fetchPhotos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

