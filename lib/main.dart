import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  // print('CLIENT!!');
  // print(client);
  // Criando uma instancia de Response, que contem os dados do servidor
  final response =
  await client.get('https://jsonplaceholder.typicode.com/photos');

  // print('>>>>>>>RESPONSE<<<<<<<<');
  // print(response.body);
  // print('>>>>>>>RESPONSE<<<<<<<<');


  // Usa a função compute para executar parsePhotos em uma isolate separada.
  return compute(parsePhotos, response.body);
}

// Uma função que converte o response.body de json para List<Photo>.
List<Photo> parsePhotos(String responseBody) {

  // print('responseBody!!');
  // print(responseBody);
  // print('responseBody!!');

  // Re-tipa o responseBody de json para Map
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  // print('XXXXXXXXXXXXXXXX');
  // print(parsed.runtimeType);
  // print('XXXXXXXXXXXXXXXX');


  // Retornando uma lista de Maps
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  // Construtor da classe
  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  // Função que recebe Maps de uma lista
  factory Photo.fromJson(Map<String, dynamic> json) {
    // print('json!!!!');
    // print(json);
    // Recebe item por item da lista
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // FutureBuilder que recebe a lista de Photo
      body: FutureBuilder<List<Photo>>(
        // A future é o processamento do json do servidor
        future: fetchPhotos(http.Client()),
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

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}