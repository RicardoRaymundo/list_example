import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Carrega o conteudo da API
Future<List<Photo>> fetchPhotos() async {
  final client = http.Client();

  // Criando uma instancia de Response, que contem os dados do servidor
  final response = await client.get('https://jsonplaceholder.typicode.com/photos');

  // Usa a função compute para executar parsePhotos em uma isolate separada.
  return compute(parsePhotos, response.body);
}

// Converte o conteúdo de response.body de json para List<Photo>.
List<Photo> parsePhotos(String responseBody) {

  // Re-tipa o responseBody de json para Map
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);

  final funcaoAnonima = (json) => Photo.fromJsonx(json);

  final parsedMap = parsed.map<Photo>(funcaoAnonima);

  print(parsedMap);

  // Retornando uma lista de Maps
  return parsedMap.toList();
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
  factory Photo.fromJsonx(Map<String, dynamic> json) {
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