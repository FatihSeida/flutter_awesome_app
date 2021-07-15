import 'dart:convert';
import 'package:awesome_app/modules/cache/photo_cache.dart';
import 'package:awesome_app/modules/photo/models/album.dart';

import 'package:http/http.dart' as http;

class PhotoRepository {
  final String baseUrl = 'https://api.pexels.com/v1';
  final String apiKey =
      '563492ad6f91700001000001e458179fd602449ca12c3932ba5ae83c ';
  final PhotoCache cache;

  PhotoRepository(this.cache);

  Future<Album> fetchPhoto([int page = 1]) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/curated?page=$page&per_page=20"), headers: {
        'Authorization': '$apiKey',
      });
      final results = json.decode(response.body.toString());
      cache.set(results['photos']);
      return Album.fromMap(results);
    } catch (e) {
      throw e;
    }
  }
}
