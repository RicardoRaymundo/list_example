import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos() async {
  final client = http.Client();

  // print('CLIENT!!');
  print(client);
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
  print(parsed.runtimeType);
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